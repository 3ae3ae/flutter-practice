import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: 'Flutter layout demo', home: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Expanded(
          child: Image.asset('assets/images/landscape.png', fit: BoxFit.cover),
        ),
        const Expanded(
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
    return Column(
      children: [TitleSection(), ButtonSection(), Divider(), textSection],
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final T = Theme.of(context).textTheme;

    return Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Oeschinen Lake Campground',
                      style: T.titleMedium,
                    ),
                  ),
                  Text(
                    "Kandersteg, Switzeland",
                    style: T.labelMedium,
                  )
                ],
              ),
            ),
            Icon(
              Icons.star,
              color: Colors.orange,
            ),
            Text('41'),
          ],
        ));
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  Column _buildButton(Color color, IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(
          label,
          style: TextStyle(color: color),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildButton(color, Icons.call, 'call'),
        _buildButton(color, Icons.route, 'route'),
        _buildButton(color, Icons.share, 'share'),
      ]),
    );
  }
}

Widget textSection = const Padding(
  padding: EdgeInsets.all(32),
  child: Text(
    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
    'Alps. Situated 1,578 meters above sea level, it is one of the '
    'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
    'half-hour walk through pastures and pine forest, leads you to the '
    'lake, which warms to 20 degrees Celsius in the summer. Activities '
    'enjoyed here include rowing, and riding the summer toboggan run.',
    softWrap: true,
  ),
);
