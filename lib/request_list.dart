import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import 'request.dart';

class RequestList extends StatefulWidget {
  const RequestList({
    super.key,
    required this.activeRequests,
    required this.acceptAction,
    required this.declineAction,
    required this.gameTime,
  });

  final List<Request> activeRequests;
  final Future<void> Function(String, String) acceptAction;
  final Future<void> Function(String, String) declineAction;
  final String gameTime;

  @override
  State<StatefulWidget> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    String? username = FirebaseAuth.instance.currentUser!.displayName;
    return Container(
      width: 300,
      color: const Color.fromARGB(255, 239, 174, 106),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (Request x in widget.activeRequests)
            if (x.requestee == username && x.gameTime == widget.gameTime)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(0, 230, 168, 52),
                ),
                child: Column(
                  children: [
                    Text('${x.requestor} invites you to a game: ${x.gameTime}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
// If the requestor is registered as needing a partner, he is not deregistered.
// To reproduce, there must be another player registered as needing partner.
// Then, register as needing a partner.
// Request a game of this other player.
// If the other player accepts, you will show up as with AND without partner.                           
                            widget.acceptAction(x.gameTime, x.requestor);
                          },
                          child: Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.declineAction(x.gameTime, x.requestor);
                          },
                          child: Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
