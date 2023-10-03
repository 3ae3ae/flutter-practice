import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:english_words/english_words.dart';

class CounterNameNotifier extends StateNotifier<List<String>> {
  CounterNameNotifier() : super([]);

  void addName(String name) {
    state = [...state, name];
  }

  void changeName(int index, String name) {
    state.replaceRange(index, index + 1, [name]);
    state = state.toList();
  }

  void removeName(int index) {
    state.removeAt(index);
    state = state.toList();
  }
}

class CounterValueNotifier extends StateNotifier<List<int>> {
  CounterValueNotifier() : super([]);
  void addValue(int n) {
    state = [...state, n];
  }

  void removeValue(int index) {
    state.removeAt(index);
    state = state.toList();
  }

  void changeValue(int index, int i) {
    state[index] += i;
    state = state.toList();
  }
}

class CounterHSLNotifier extends StateNotifier<List<HSLColor>> {
  CounterHSLNotifier() : super([]);

  void addHSL(double H, double S, double L) {
    state = [...state, HSLColor.fromAHSL(1, H, S, L)];
  }

  void removeHSL(int index) {
    state.removeAt(index);
    state = state.toList();
  }

  void changeHSL(int index, double H, double S, double L) {
    state.replaceRange(index, index + 1, [HSLColor.fromAHSL(1, H, S, L)]);
    state = state.toList();
  }

  Color returnTextColor(int index) {
    return state[index].lightness > 0.5 ? Colors.black : Colors.white;
  }
}

final counterNameProvider =
    StateNotifierProvider<CounterNameNotifier, List<String>>(
        (ref) => CounterNameNotifier());
final counterValueProvider =
    StateNotifierProvider<CounterValueNotifier, List<int>>(
        (ref) => CounterValueNotifier());
final counterHSLProvider =
    StateNotifierProvider<CounterHSLNotifier, List<HSLColor>>(
        (ref) => CounterHSLNotifier());

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: MainApp())));
}

class Test extends ConsumerWidget {
  const Test({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Row(
        children: [
          // SizedBox(height: double.infinity),
          SizedBox(
            height: 50,
            width: 50,
            child: ColoredBox(color: Colors.amber),
          )
        ],
      ),
    );
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  ref
                      .watch(counterNameProvider.notifier)
                      .addName(nouns[Random().nextInt(2500)]);
                  ref.watch(counterValueProvider.notifier).addValue(0);
                  ref.watch(counterHSLProvider.notifier).addHSL(
                      Random().nextDouble() * 360,
                      Random().nextDouble(),
                      Random().nextDouble());
                },
                icon: const Icon(Icons.add))
          ],
          title: const Text('Counter'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final itemCount = ref.watch(counterNameProvider).length;
            if (constraints.maxHeight > itemCount * 112) {
              return Column(
                children: [
                  for (var i = 0; i < itemCount; i++)
                    Expanded(child: Counter(index: i))
                ],
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverList.builder(
                    itemCount: ref.watch(counterNameProvider).length,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 112,
                        ),
                        child: Counter(
                          index: index,
                        ),
                      );
                    },
                  )
                ],
              );
            }
          },
        ));
  }
}

class Counter extends ConsumerWidget {
  final int index;
  const Counter({super.key, required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(counterNameProvider)[index];
    final value = ref.watch(counterValueProvider)[index];
    final T = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          color: ref.watch(counterHSLProvider)[index].toColor(),
          constraints: const BoxConstraints(
            minHeight: 96,
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    ref
                        .read(counterValueProvider.notifier)
                        .changeValue(index, -1);
                  },
                  child: const SizedBox(
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.remove)),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    name.toString(),
                    style: T.headlineMedium?.copyWith(
                        color: ref
                            .watch(counterHSLProvider.notifier)
                            .returnTextColor(index)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        value.toString(),
                        style: T.headlineSmall?.copyWith(
                            color: ref
                                .watch(counterHSLProvider.notifier)
                                .returnTextColor(index)),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    ref
                        .read(counterValueProvider.notifier)
                        .changeValue(index, 1);
                  },
                  child: const SizedBox(
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.add)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
