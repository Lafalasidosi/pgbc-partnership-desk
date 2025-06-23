import 'dart:async';

import 'package:flutter/material.dart';

import 'src/widgets.dart';

class PartnershipDesk extends StatefulWidget {
  PartnershipDesk({
    super.key,
    required this.registerForPartner,
    required this.deregisterForPartner,
  });

  final FutureOr<void> Function() registerForPartner;
  final FutureOr<void> Function() deregisterForPartner;

  @override
  State<StatefulWidget> createState() => _PartnershipDeskState();
}

class _PartnershipDeskState extends State<PartnershipDesk> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PartnershipDeskState');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await widget.registerForPartner();
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}
