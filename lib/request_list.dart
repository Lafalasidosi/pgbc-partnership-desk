import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import 'registration.dart';
import 'request.dart';

class RequestList extends StatefulWidget {
  const RequestList({
    super.key,
    required this.activeRequests,
  });

  final List<Request> activeRequests;

  @override
  State<StatefulWidget> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RequestListState');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color.fromARGB(255, 239, 174, 106),  
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [for (var x in widget.activeRequests)
          Text('${x.requestor} invites you to ${x.gameTime}'),
        ],
      ),
      );
    
  }
}
