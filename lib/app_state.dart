import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'registration.dart';
import 'request.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  StreamSubscription<QuerySnapshot>? _partnershipDeskSubscription;
  StreamSubscription<QuerySnapshot>? _activeRequestsSubscription;
  // ignore: prefer_final_fields
  DateTime _currentDate = DateTime.now();
  DateTime get currentDate => _currentDate;
  set currentDate(DateTime t) {
    DateTime.now();
  }

  String partnersCollection = 'partnershipdesk';
  String requestsCollection = 'requests';
  List<Registration> _registeredPlayers = [];
  List<Registration> get registeredPlayers => _registeredPlayers;
  List<Request> _activeRequests = [];
  List<Request> get activeRequests => _activeRequests;

  void resetCurrentDate(Timer t) {
    currentDate = DateTime.now();
    notifyListeners();
  }

  FutureOr<void> clearOldPartnershipDesks() async {
    // For every listing in collection "partnershipdesk", convert the gameTime
    // field into a DateTime. Then, if that document's date is before the
    // _currentDate, delete it.
    var olds = FirebaseFirestore.instance
                  .collection(partnersCollection)
                  .get();

        olds.then((snapshot) {
          for (var doc in snapshot.docs) {
            String oldDateAsString = doc.get('gameTime');
            
            DateTime oldDate = DateTime.parse(oldDateAsString);
            if (currentDate.isAfter(oldDate)) {
              doc.reference.delete();
            }
          }
        });
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Timer.periodic(Duration(days: 1), resetCurrentDate);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    String? name = FirebaseAuth.instance.currentUser?.displayName;

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _partnershipDeskSubscription = FirebaseFirestore.instance
            .collection(partnersCollection)
            .snapshots()
            .listen((snapshot) {
              _registeredPlayers = [];
              for (final document in snapshot.docs) {
                _registeredPlayers.add(
                  Registration(
                    gameTime: document.get('gameTime'),
                    player1: document.get('player1'),
                    player2: document.get('player2'),
                  ),
                );
              }
              notifyListeners();
            });
        _activeRequestsSubscription = FirebaseFirestore.instance
            .collection(requestsCollection)
            // .where('requestee', isEqualTo: name)
            .snapshots()
            .listen((snapshot) {
              _activeRequests = [];
              for (var document in snapshot.docs) {
                var x = document.get('gameTime') as String;
                var y = document.get('requestee') as String;
                var z = document.get('requestor') as String;
                _activeRequests.add(
                  Request(gameTime: x, requestee: y, requestor: z),
                );
              }
              notifyListeners();
            });
      } else {
        _loggedIn = false;
        _partnershipDeskSubscription?.cancel();
        _activeRequestsSubscription?.cancel();
      }
      notifyListeners();
    }); // FirebaseAuth
  } // Future<void>

  Future<void> sendRequest(String gameTime, String requestee) {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }
    String requestor = FirebaseAuth.instance.currentUser!.displayName!;
    assert(requestor != requestee);

    return FirebaseFirestore.instance.collection(requestsCollection).add(
      <String, dynamic>{
        'gameTime': gameTime,
        'requestee': requestee,
        'requestor': requestor,
      },
    );
  }

  Future<void> deleteRequest(String gameTime, String requestor) async {
    String requestee = FirebaseAuth.instance.currentUser!.displayName!;
    assert(requestee != requestor);

    await FirebaseFirestore.instance
        .collection(requestsCollection)
        .where('gameTime', isEqualTo: gameTime)
        .where('requestee', isEqualTo: requestee)
        .where('requestor', isEqualTo: requestor)
        .get()
        .then((snapshot) {
          var doc = snapshot.docs.first;
          doc.reference.delete();
        });
  }

  Future<void> acceptAction(String gameTime, String requestor) async {
    await deregister();
    addPlayerWithPartner(gameTime, requestor);
    deleteRequest(gameTime, requestor);
  }

  /// Create a document in collection "partnershipdesk" for player
  /// for a given `gameTime` with null "player2" field.
  Future<void> addPlayerLookingForPartner(String gameTime) async {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String? name = FirebaseAuth.instance.currentUser!.displayName;

    QuerySnapshot registration =
        await FirebaseFirestore.instance
            .collection(partnersCollection)
            .where('gameTime', isEqualTo: gameTime)
            .where('player1', isEqualTo: name)
            .get();

    if (registration.docs.isEmpty) {
      FirebaseFirestore.instance
          .collection(partnersCollection)
          .add(<String, dynamic>{
            'player1': FirebaseAuth.instance.currentUser!.displayName,
            'player2': null,
            'gameTime': gameTime,
          });
    } // FirebaseFirestore
  }

  /// For a given `gameTime`, add a document to collection
  /// "partnershipdesk" with calling user as "player1" and
  /// given `player2` as "player2".
  Future<void> addPlayerWithPartner(String gameTime, String player2) async {
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String? player1 =
        FirebaseAuth
            .instance
            .currentUser!
            .displayName; // ought these become user IDs instead?

    QuerySnapshot registration =
        await FirebaseFirestore.instance
            .collection(partnersCollection)
            .where('gameTime', isEqualTo: gameTime)
            .where('player1', isEqualTo: player1)
            .get();

    if (registration.docs.isEmpty) {
      FirebaseFirestore.instance.collection(partnersCollection).add(
        <String, dynamic>{
          'player1': player1,
          'player2': player2,
          'gameTime': gameTime,
        },
      );
    }
  }

  /// Delete a user's registration at his request.
  /// If already registered, the user will be either "player1" or
  /// "player2" in the corresponding Firebase document. No matter
  /// which is the case, amend the document so that the player
  /// originally registered with remains so but with no partner.
  Future<void> deregister() async {
    // Assumes the calling user is registered for a given game.
    if (!_loggedIn) {
      throw Exception('You must be logged in to do that!');
    }

    String name = FirebaseAuth.instance.currentUser!.displayName!;
    String? pname;
    CollectionReference db = FirebaseFirestore.instance.collection(
      partnersCollection,
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
    var nextDay = getUpcomingDay(DateTime.now(), dayOfWeek);
    var nextDayNoHour = nextDay.toString().split(' ')[0];
    return nextDayNoHour;
  }
}
