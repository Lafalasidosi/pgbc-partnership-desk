import 'dart:async';

import 'package:flutter/material.dart';

import 'src/widgets.dart';

class PartnershipDesk extends StatefulWidget {
  PartnershipDesk({
    super.key,
    required this.registerForPartner,
    required this.deregisterForPartner,
    required this.upcomingGameDate,
  });

  final FutureOr<void> Function(int) registerForPartner;
  final FutureOr<void> Function() deregisterForPartner;
  final String upcomingGameDate;

  @override
  State<StatefulWidget> createState() => _PartnershipDeskState();
}

class _PartnershipDeskState extends State<PartnershipDesk> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PartnershipDeskState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                await widget.registerForPartner(2); // what if you have more than one session in a day?
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
        ],
      ),
    );
  }
}
