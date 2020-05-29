import 'mutator.dart';

class LoggingMutator<T> extends Mutator<T> {
  final Mutator<T> inner;

  const LoggingMutator(this.inner);

  @override
  T mutate(T oldValue, Mutation<T> mutation) {
    final newValue = inner.mutate(oldValue, mutation);
    print('Mutated $oldValue to $newValue from mutation ${mutation}');
    return newValue;
  }
}
