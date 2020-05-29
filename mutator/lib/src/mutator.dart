import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class Mutator<T> {
  const Mutator();
  T mutate(T oldValue, Mutation<T> mutation);
}

extension MutatorContextExtensions on BuildContext {
  T listen<T>() => Provider.of<ValueNotifier<T>>(this).value;
  R property<T, R>(R Function(T value) selector) =>
      select<ValueNotifier<T>, R>((notifier) => selector(notifier.value));
  T value<T>() => Provider.of<ValueNotifier<T>>(this, listen: false).value;
  Dispatcher<T> dispatcher<T>(BuildContext context) => Dispatcher<T>(context);
}

class Dispatcher<T> {
  final BuildContext context;
  const Dispatcher(this.context);

  void dispatch(Mutation<T> mutation) {
    final notifier = Provider.of<ValueNotifier<T>>(context, listen: false);
    final mutator = Provider.of<Mutator<T>>(context, listen: false);

    if (mutation is ThunkMutation<T>) {
      mutation.execute(notifier.value, mutator).then(
        (thunk) {
          dispatch(
            ThunkSucceededMutation(
              mutation,
              thunk(notifier.value),
            ),
          );
        },
      ).catchError((e, st) {
        dispatch(
          ThunkFailedMutation(
            mutation,
            e,
            st,
          ),
        );
      });
    }

    notifier.value = mutator.mutate(notifier.value, mutation);
  }
}

abstract class Mutation<T> {
  String get name;
  Map<String, Object> get arguments;
  const Mutation();
}

class Mutated<T> extends StatelessWidget {
  final T initialValue;
  final Mutator<T> mutator;
  final Widget child;
  final WidgetBuilder builder;

  const Mutated({
    Key key,
    this.child,
    this.builder,
    @required this.initialValue,
    @required this.mutator,
  })  : assert(child != null || builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ValueNotifier<T>(initialValue),
      child: Provider<Mutator<T>>.value(
        value: mutator,
        child: child ??
            Builder(
              builder: (context) => builder(context),
            ),
      ),
    );
  }
}

typedef Thunk<T> = T Function(T state);

abstract class ThunkMutation<T> extends Mutation<T> {
  const ThunkMutation();
  Future<Thunk<T>> execute(T initialValue, Mutator<T> mutator);
}

class ThunkSucceededMutation<T> extends Mutation<T> {
  final ThunkMutation<T> from;
  final T result;
  const ThunkSucceededMutation(this.from, this.result);

  @override
  Map<String, Object> get arguments => from.arguments;

  @override
  String get name => '${from}(Completed)';
}

class ThunkFailedMutation<T> extends Mutation<T> {
  final ThunkMutation<T> from;
  final dynamic error;
  final StackTrace stackTrace;
  const ThunkFailedMutation(this.from, this.error, this.stackTrace);

  @override
  Map<String, Object> get arguments => from.arguments;

  @override
  String get name => '${from}(Failed)';
}
