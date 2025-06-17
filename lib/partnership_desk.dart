import 'dart:async';

import 'package:flutter/material.dart';

// import 'guest_book_message.dart';
import 'src/widgets.dart';

class PartnershipDesk extends StatefulWidget {
  const PartnershipDesk({super.key, required this.registerForPartner, required this.deregisterForPartner});

  final FutureOr<void> Function() registerForPartner;
  final FutureOr<void> Function() deregisterForPartner;

  @override
  State<StatefulWidget> createState() => _PartnershipDeskState();
}

class _PartnershipDeskState {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PartnershipDeskState');
}

