import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'registration.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  StreamSubscription<QuerySnapshot>? _partnershipDeskSubscription;
  DateTime get currentDate => DateTime.now();
  String collectionName = 'partnershipdesk';
  List<Registration> _registeredPlayers = [];
  List<Registration> get registeredPlayers => _registeredPlayers;

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
            .listen((snapshot) {
              _registeredPlayers = [];
              for (final document in snapshot.docs) {
                _registeredPlayers.add(
                  Registration(
                    game: document.get('game'),
                    player1: document.get('player1'),
                    player2: document.get('player2'),
                  ),
                );
              }
              notifyListeners();
            });
      } else {
        _loggedIn = false;
        _partnershipDeskSubscription?.cancel();
      }
      notifyListeners();
    }); // FirebaseAuth
  } // Future<void>

  Future<void> addPlayerLookingForPartner(String gameTime) async {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String? name = FirebaseAuth.instance.currentUser!.displayName;

    QuerySnapshot registration =
        await FirebaseFirestore.instance
            .collection(collectionName)
            .where('game', isEqualTo: gameTime)
            .where('player1', isEqualTo: name)
            .get();

    if (registration.docs.isEmpty) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .add(<String, dynamic>{
            'player1': FirebaseAuth.instance.currentUser!.displayName,
            'player2': null,
            'game': gameTime,
          });
    } // FirebaseFirestore
  }

  Future<void> addPlayerWithPartner(String gameTime, String player2) {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String? player1 =
        FirebaseAuth
            .instance
            .currentUser!
            .displayName; // ought these become user IDs instead?

    return FirebaseFirestore.instance.collection(collectionName).add(
      <String, dynamic>{
        'player1': player1,
        'player2': player2,
        'game': gameTime,
      },
    );
  }

  /// Delete a user's registration at his request, updating his or her
  /// partner's registration to "looking for partner", if it exists.
  void deregister() async {
    // Assumes the calling user is registered for a given game.
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String name = FirebaseAuth.instance.currentUser!.displayName!;
    String? pname;
    CollectionReference db = FirebaseFirestore.instance.collection(
      collectionName,
    );

    // delete calling user's registration
    var regQuery = db.where(
      Filter.or(
        Filter('player1', isEqualTo: name),
        Filter('player2', isEqualTo: name),
      ),
    );

    QuerySnapshot querySnapshot = await regQuery.get();

    for (var x in querySnapshot.docs) {
      if (x.get('player1') == name) {
        pname = x.get('player2');
        if (pname == null) {
          x.reference.delete();
        } else {
          x.reference.update({'player1': pname, 'player2': null});
        }
      } else {
        x.reference.update({'player2': null});
      }
    }
  }

  /// Given a DateTime representation of the current date and an integer
  /// corresponding to the day of the week (Monday: 1, Tuesday: 2, etc.),
  /// return the date of the next occurence of the indicated weekday.
  ///
  /// For example, if `today` is Monday, August 24 3542 and `dayOfWeek` is
  /// 4, return Thursday, August 27 3542.
  DateTime getUpcomingDay(DateTime today, int dayOfWeek) {
    while (today.weekday != dayOfWeek) {
      today = today.add(const Duration(days: 1));
    }
    return today;
  }

  /// Extends `getUpcomingDay` to return a String instead of DateTime.
  String getUpcomingDayAsString(int dayOfWeek) {
    // This method and `getUpcomingDay` are currently pretty hard-coded.

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
