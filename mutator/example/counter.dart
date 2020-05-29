import 'package:flutter/widgets.dart';
import 'package:mutator/mutator.dart';

part 'counter.g.dart';

class Counter {
  final int value;
  const Counter(this.value);
}

class CounterMutator extends Mutator<Counter> with _CounterMutator {
  const CounterMutator();
  Counter add(Counter counter, int value) {
    return Counter(counter.value + value);
  }

  Future<Thunk<Counter>> addFromServer(Counter counter) async {
    // Simulating a server call.
    await Future.delayed(const Duration(seconds: 10));
    final valueFromServer = 10;
    return (counter) {
      // `counter` may have change during server call
      return Counter(counter.value + valueFromServer);
    };
  }
}
