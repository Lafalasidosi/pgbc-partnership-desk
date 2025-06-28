import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'src/widgets.dart';

class PartnershipDesk extends StatefulWidget {
  PartnershipDesk({
    super.key,
    required this.loggedIn,
    required this.registerForPartner,
    required this.deregisterForPartner,
    required this.registerWithPartner,
    required this.upcomingGameDate,
  });

  final bool loggedIn;
  final FutureOr<void> Function(int) registerForPartner;
  final FutureOr<void> Function() deregisterForPartner;
  final FutureOr<void> Function(int, String) registerWithPartner;
  final String upcomingGameDate;

  @override
  State<StatefulWidget> createState() => _PartnershipDeskState();
}

class _PartnershipDeskState extends State<PartnershipDesk> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PartnershipDeskState');
  final _controller = TextEditingController();
  final db = FirebaseFirestore.instance.collection('partnershipdesk');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 300,
        alignment: Alignment.center,
        color: Color.fromARGB(160, 0, 228, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Upcoming game:'),
            Text(widget.upcomingGameDate),
            Padding(
              padding: EdgeInsets.all(2),
              child: ElevatedButton(
                onPressed: () async {
                  await widget.registerForPartner(2);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(187, 126, 3, 240),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Color(0xffffffff)),
                ),
                child: Text('I need a partner'),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 30, end: 30),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(helperText: 'Partner\'s name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your partner\'s name, please.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: ElevatedButton(
                onPressed: () async {
                  await widget.registerWithPartner(2, _controller.text);
                  _controller.clear();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(187, 126, 3, 240),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Color(0xffffffff)),
                ),
                child: Text('I have a partner.'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: ElevatedButton(
                onPressed: () async {
                  await widget.deregisterForPartner();
                  setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(187, 126, 3, 240),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Color(0xffffffff)),
                ),
                child: Text('Unregister'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
