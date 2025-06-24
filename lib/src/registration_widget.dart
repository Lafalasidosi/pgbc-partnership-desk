import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegistrationWidget extends StatefulWidget {
  RegistrationWidget({
    super.key,
    required this.weekday,
    required this.loggedIn,
  });

  final int weekday;
  final bool loggedIn;

  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  var currentDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    String currentDateAsString =
        "${dayMap[currentDate.weekday]}, ${monthMap[currentDate.month]} ${currentDate.day} ${currentDate.year} 6:45pm";
    String nextGame = getUpcomingDay(currentDate, widget.weekday).toString();
    var db = FirebaseFirestore.instance.collection(nextGame);
    String? uname = FirebaseAuth.instance.currentUser!.displayName;
    return Visibility(
      visible: widget.loggedIn,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Upcoming game:'),
            Text(nextGame),
            RegistrationButton(
              text: 'I need a partner',
              function: () {
                db
                .doc(uname) // Already a player can't register more than once, unlike before
                .set(
                  <String, dynamic>{
                    'username': uname,
                    'game': nextGame,
                    'partner': null,
                  }  
                );
              },
            ),
            RegistrationButton(
              text: 'I have a partner', 
              function: () {}),
            RegistrationButton(
              text: 'Unregister',
              function: () {
                db.doc(uname).delete(); // maybe add then() for logging
              }
            )
          ],
        ),
      ),
    );
  }

  String getUpcomingDay(DateTime today, int dayOfWeek) {
    String? weekdayName;
    String? monthName;
    int date;
    int year;
    String time = '6:45pm';

    // Tuesdays are 2, Thursdays are 4
    while (today.weekday != dayOfWeek) {
      today = today.add(const Duration(days: 1));
    }

    weekdayName = dayMap[dayOfWeek];
    monthName = monthMap[today.month];
    year = today.year;
    date = today.day;

    return "$weekdayName, $monthName $date $year $time";
  }
}

class RegistrationButton extends StatelessWidget {
  final String text;
  final VoidCallback? function;
  const RegistrationButton({super.key, required this.text, this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: function,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Color.fromARGB(187, 126, 3, 240),
          ),
          foregroundColor: WidgetStatePropertyAll(Color(0xffffffff)),
        ),
        child: Text(text),
      ),
    );
  }
}
