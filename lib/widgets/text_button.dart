import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.buttonColor,  this.icon,  this.iconColor, this.buttonWidth,

  });

  final String text;
 final   IconData? icon;
  final Color buttonColor;
   final Function()? onPressed;
     final Color? iconColor;
     final double? buttonWidth;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          fixedSize:  Size (buttonWidth?? 150, 39.5),
          backgroundColor: buttonColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon,color: iconColor,
          size: 30,),
          Text(
            text,
            style: const TextStyle(
              color:Color(0xff4A4A4A),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Baloo Thambi 2"
            ),
          ),
        ],
      ),
    );
  }
}
