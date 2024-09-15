import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    required this.buttonColor, this.buttonWidth,

  });

  final String text;

  final Color buttonColor;
   final Function()? onPressed;
   final double?buttonWidth;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          fixedSize:  Size(buttonWidth?? 282.4, 46),
          backgroundColor: buttonColor),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Baloo Thambi 2"
        ),
      ),
    );
  }
}
