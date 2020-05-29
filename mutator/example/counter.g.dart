part of 'counter.dart';

mixin _CounterMutator {
  Counter mutate(Counter oldValue, Mutation<Counter> mutation) {
    final self = this as CounterMutator;

    if (mutation is AddCounterMutation) {
      return self.add(oldValue, mutation.value);
    }

    return oldValue;
  }
}

class AddCounterMutation extends Mutation<Counter> {
  final int value;
  const AddCounterMutation({
    @required this.value,
  });
}

extension CounterDispatcherExtensions on Dispatcher<Counter> {
  void add({@required int value}) => dispatch(
        AddCounterMutation(
          value: value,
        ),
      );
}
