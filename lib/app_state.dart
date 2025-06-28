import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

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
  DateTime get currentDate => DateTime.now();
  String collectionName = 'partnershipdesk';

  // Funtions
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _partnershipDeskSubscription = FirebaseFirestore.instance
            .collection('partnershipdesk')
            .snapshots()
            .listen((snapshot) {});
        notifyListeners();
      } else {
        _loggedIn = false;
        _partnershipDeskSubscription?.cancel();
      }
      notifyListeners();
    }); // FirebaseAuth
  } // Future<void>

  Future<void> addPlayerLookingForPartner(String gameTime, int dayOfWeek) {
    /* Check first if player is already registered for a particular game
    */

    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    return FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .set(<String, dynamic>{
          'partner': null,
          'game': gameTime,
        }); // FirebaseFirestore
  }

  Future<void> addPlayerWithPartner(String gameTime, String pname) {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    return FirebaseFirestore.instance
        .collection(collectionName)
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .set(<String, dynamic>{
          'partner': pname,
          'game': gameTime,
        });
  }

  void deregister() async {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String name = FirebaseAuth.instance.currentUser!.displayName!;
    String? partnerName;

    var player = FirebaseFirestore.instance.collection(collectionName)
                  .doc(name);

    player.delete();
  }

  DateTime getUpcomingDay(DateTime today, int dayOfWeek) {
    while (today.weekday != dayOfWeek) {
      today = today.add(const Duration(days: 1));
    }
    return today;
  }

  String getUpcomingDayAsString(int dayOfWeek) {
    DateTime today = DateTime.now();
    String? weekdayName;
    String? monthName;
    int date;
    int year;
    String time = '6:45pm';
    final Map<int, String> dayMap = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };

    final Map<int, String> monthMap = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };

    DateTime gameDay = getUpcomingDay(today, dayOfWeek);

    weekdayName = dayMap[dayOfWeek];
    monthName = monthMap[gameDay.month];
    year = gameDay.year;
    date = gameDay.day;

    return "$weekdayName, $monthName $date $year $time";
  }
}
