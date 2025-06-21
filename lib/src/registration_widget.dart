import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegistrationWidget extends StatefulWidget {
  RegistrationWidget({super.key, required this.day});
  
  final int day;
  
  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  var currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(getUpcomingDay(currentDate, widget.day).toString()),
          RegistrationButton(text: 'I need a partner'),
          RegistrationButton(text: 'I have a partner'),
        ],
      ),
    );
  }

  DateTime getUpcomingDay(DateTime today, int dayOfWeek) {
    // Tuesdays are 2, Thursdays are 4
    while (today.weekday != dayOfWeek) {  
      today = today.add(const Duration(days: 1));
    }
    return today;
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
          backgroundColor: WidgetStatePropertyAll(Color(0xff5000aa)),
          foregroundColor: WidgetStatePropertyAll(Color(0xffffffff)),
        ),
        child: Text(text),
      ),
    );
  }
}
