import 'dart:async';

import 'package:flutter/material.dart';
import 'player.dart';

// import 'guest_book_message.dart';
import 'src/widgets.dart';

class PartnershipDesk extends StatefulWidget {
  PartnershipDesk({super.key, required this.registerForPartner, required this.deregisterForPartner});

  final FutureOr<void> Function() registerForPartner;
  final FutureOr<void> Function() deregisterForPartner;
  final List<Player> players = [];

  @override
  State<StatefulWidget> createState() => _PartnershipDeskState();
}

class _PartnershipDeskState extends State<PartnershipDesk>{
  final _formKey = GlobalKey<FormState>(debugLabel: '_PartnershipDeskState');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var p in widget.players)
          ElevatedButton(onPressed: () {}, child: Text(p.getName()))
      ],
    );
  }
}

