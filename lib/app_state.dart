import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdv0/player.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  // Constructor
  ApplicationState() {
    init();
  }

  // Member variables
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  StreamSubscription<QuerySnapshot>? _partnershipDeskSubscription;
  List<Player> _players = [];
  List<Player> get players => _players;
  var currentDate = DateTime.now();

  // Funtions
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    // There's a lot going on here, so you should explore it in a debugger to inspect what happens to get a clearer mental model.
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _partnershipDeskSubscription = FirebaseFirestore.instance
            .collection('partnershipdesk')
            .snapshots()
            .listen((snapshot) {
              _players = [];
              for (final document in snapshot.docs) {
                _players.add(
                  Player(
                    name:
                        FirebaseAuth.instance.currentUser!.displayName
                            as String,
                  ),
                );
              }
            });
        notifyListeners();
      } else {
        _loggedIn = false;
        _players = [];
        _partnershipDeskSubscription?.cancel();
      }
      notifyListeners();
    }); // FirebaseAuth
  } // Future<void>

  Future<DocumentReference> addPlayerToPartnershipDesk() {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    return FirebaseFirestore.instance
        .collection('partnershipdesk')
        .add(<String, dynamic>{
          'username': FirebaseAuth.instance.currentUser!.displayName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'userID': FirebaseAuth.instance.currentUser!.uid,
        }); // FirebaseFirestore
  }

  // DateTime next
}
