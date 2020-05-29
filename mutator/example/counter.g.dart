part of 'counter.dart';

mixin _CounterMutator {
  Counter mutate(Counter oldValue, Mutation<Counter> mutation) {
    final self = this as CounterMutator;

    if (mutation is AddCounterMutation) {
      return self.add(oldValue, mutation.value);
    }

    if (mutation is ThunkSucceededMutation<Counter>) {
      return mutation.result;
    }

    return oldValue;
  }
}

class AddCounterMutation extends Mutation<Counter> {
  final int value;
  const AddCounterMutation({
    @required this.value,
  });

  @override
  Map<String, Object> get arguments => {
        'value': value,
      };

  @override
  String get name => 'add';
}

class AddFromServerCounterMutation extends ThunkMutation<Counter> {
  const AddFromServerCounterMutation();

  @override
  Map<String, Object> get arguments => {};

  @override
  String get name => 'addFromServer';

  @override
  Future<Thunk<Counter>> execute(
      Counter initialValue, Mutator<Counter> mutator) {
    final self = this as CounterMutator;
    return self.addFromServer(initialValue);
  }
}

extension CounterDispatcherExtensions on Dispatcher<Counter> {
  void add({@required int value}) => dispatch(
        AddCounterMutation(
          value: value,
        ),
      );

  void addFromServer() => dispatch(
        AddFromServerCounterMutation(),
      );
}
