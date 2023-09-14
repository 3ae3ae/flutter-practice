import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Placeholder(),
        ),
        Expanded(
          flex: 2,
          child: Dialog(),
        )
      ],
    ));
  }
}

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Title(),
        Expanded(
          child: Placeholder(),
        )
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Oeschinen Lake Campground',
                style: Theme.of(context).textTheme.titleMedium),
            const Icon(Icons.star),
          ],
        ));
  }
}
