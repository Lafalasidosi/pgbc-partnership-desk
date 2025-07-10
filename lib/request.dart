import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Request extends StatelessWidget {
  Request({
    required this.requestor,
    required this.requestee,
    required this.gameTime,
  });

  String requestor;
  String requestee;
  String gameTime;

  @override
  Widget build(BuildContext context) {
    Widget result;
    result = Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color.fromARGB(0, 230, 168, 52),
      ),
      child: Column(
        children: [
          Text('$requestor invites you to a game: $gameTime'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Accept')),
              ElevatedButton(onPressed: () {}, child: Text('Decline')),
            ],
          ),
        ],
      ),
    );
    return result;
  }
}
