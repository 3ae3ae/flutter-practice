import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:english_words/english_words.dart';

class Counter {
  String name;
  int value;
  HSLColor hslColor;
  Color _textColor = Colors.amber;
  Counter({required this.name, required this.value, required this.hslColor}) {
    _textColor = hslColor.lightness > 0.5 ? Colors.black : Colors.white;
  }

  void changeName(String newName) {
    name = newName;
  }

  void changeHSL(HSLColor newHslColor) {
    hslColor = newHslColor;
    _textColor = hslColor.lightness > 0.5 ? Colors.black : Colors.white;
  }

  void changeValue(int newValue) {
    value = newValue;
  }

  void plusValue(int amount) {
    value += amount;
  }

  Color returnTextColor() {
    return _textColor;
  }
}

class CounterNotifier extends StateNotifier<List<Counter>> {
  CounterNotifier() : super([]);

  void addCounter(
      {required String name, required int value, required HSLColor hslColor}) {
    state = [...state, Counter(name: name, hslColor: hslColor, value: value)];
  }

  void changeName({required int index, required String newName}) {
    state[index].changeName(newName);
    state = state.toList();
  }

  void changeHSL({required int index, required HSLColor newHslColor}) {
    state[index].changeHSL(newHslColor);
    state = state.toList();
  }

  void changeValue({required int index, required int newValue}) {
    state[index].changeValue(newValue);
    state = state.toList();
  }

  void plusValue({required int index, required int amount}) {
    state[index].plusValue(amount);
    state = state.toList();
  }

  void removeCounter({required int index}) {
    state.removeAt(index);
    state = state.toList();
  }
}

final counterProvider =
    StateNotifierProvider<CounterNotifier, List<Counter>>((ref) {
  return CounterNotifier();
});

final counterLengthProvider = StateProvider<int>((ref) {
  return 0;
});

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
                  final HSLColor hslColor = HSLColor.fromAHSL(
                      1,
                      Random().nextDouble() * 360,
                      Random().nextDouble(),
                      Random().nextDouble());
                  final String name = nouns[Random().nextInt(2500)];
                  ref
                      .read(counterProvider.notifier)
                      .addCounter(name: name, value: 0, hslColor: hslColor);
                  ref
                      .read(counterLengthProvider.notifier)
                      .update((state) => state + 1);
                },
                icon: const Icon(Icons.add))
          ],
          title: const Text('Counter'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            print('builded');
            final itemCount = ref.watch(counterLengthProvider);
            if (itemCount == 0) {
              return InkWell(
                onTap: () {
                  // final HSLColor hslColor = HSLColor.fromAHSL(
                  //     1,
                  //     Random().nextDouble() * 360,
                  //     Random().nextDouble(),
                  //     Random().nextDouble());
                  // final String name = nouns[Random().nextInt(2500)];
                  // ref
                  //     .read(counterProvider.notifier)
                  //     .addCounter(name: name, value: 0, hslColor: hslColor);
                  // ref
                  //     .read(counterLengthProvider.notifier)
                  //     .update((state) => state + 1);
                },
                child: const Center(
                  child: Text('오른쪽 위의 + 버튼을 눌러 카운터를 추가하세요'),
                ),
              );
            }
            if (constraints.maxHeight > itemCount * 112) {
              return Column(
                children: [
                  for (var i = 0; i < itemCount; i++)
                    Expanded(child: CounterWidget(index: i))
                ],
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverList.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 112,
                        ),
                        child: CounterWidget(
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

class CounterWidget extends ConsumerWidget {
  final int index;
  const CounterWidget({super.key, required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("widget builded");
    // final counters = ref.watch(counterProvider);
    // final name = counters[index].name;
    // final value = counters[index].value;
    final T = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          color: ref.watch(counterProvider)[index].hslColor.toColor(),
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
                        .read(counterProvider.notifier)
                        .plusValue(index: index, amount: -1);
                  },
                  child: const SizedBox.expand(
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
                    ref.watch(counterProvider)[index].name.toString(),
                    style: T.headlineSmall?.copyWith(
                        color: ref
                            .watch(counterProvider)[index]
                            .returnTextColor()),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        ref.watch(counterProvider)[index].value.toString(),
                        style: T.headlineMedium?.copyWith(
                            color: ref
                                .watch(counterProvider)[index]
                                .returnTextColor()),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    ref
                        .read(counterProvider.notifier)
                        .plusValue(index: index, amount: 1);
                  },
                  child: const SizedBox.expand(
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
