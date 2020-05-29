import 'mutator.dart';

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
