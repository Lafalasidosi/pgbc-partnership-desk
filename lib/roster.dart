import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Roster extends StatefulWidget {
  Roster({super.key});

  @override
  State<StatefulWidget> createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Color(0xFFFF0000),
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Color(0xfa6000f0)),
            ),
            child: Text('what\'s up:'),
          ),
        ),
      ],
    );
  }
}
