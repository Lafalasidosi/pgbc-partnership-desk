


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text( 'Upcoming games')),
        body: ListView(
          children: <Widget>[
            const Text('This is where the scheule is going to go.'),
          ]
        )
      
    );
  }

}