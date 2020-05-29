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
}
