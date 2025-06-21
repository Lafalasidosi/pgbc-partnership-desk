import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegistrationWidget extends StatefulWidget {
  RegistrationWidget({super.key});

  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  var current_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(current_date.toString()),
          RegistrationButton(text: 'I need a partner'),
          RegistrationButton(text: 'I have a partner'),
        ],
      ),
    );
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
