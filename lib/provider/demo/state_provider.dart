import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state! + 1;

  int? get value => state;
}

final counterProvider = StateNotifierProvider<Counter, int?>((ref) {
  return Counter();
});

class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            ref.read(counterProvider.notifier).increment();
          },
          child: const Text('Increment counter'),
        ),
        Consumer(builder: (context, ref, child) {
          final count = ref.watch(counterProvider);
          final text = count == null ? 'Press the button' : count.toString();
          return Text(text);
        })
      ],
    );
  }
}
