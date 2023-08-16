import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const BotonAzul({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(2),
          backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
          shape: MaterialStateProperty.all(StadiumBorder())),
      onPressed: this.onPressed,
      child: Container(
          width: double.infinity,
          height: 50,
          child: Center(
              child: Text(
            this.text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ))),
    );
  }
}
