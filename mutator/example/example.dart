import 'package:flutter/material.dart';
import 'package:mutator/mutator.dart';

import 'counter.dart';

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Mutated(
      initialValue: Counter(0),
      mutator: CounterMutator(),
      builder: (context) => Scaffold(
        body: Text('Current count: ${context.listen<Counter>().value}'),
        floatingActionButton: FloatingActionButton(
            onPressed: () => context.dispatcher<Counter>(context).add(value: 1),
            child: Icon(Icons.add)),
      ),
    );
  }
}
