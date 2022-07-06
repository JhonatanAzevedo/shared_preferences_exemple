import 'package:flutter/material.dart';

class ButtomWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const ButtomWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30.0,
      child: ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
      ),
    );
  }
}
