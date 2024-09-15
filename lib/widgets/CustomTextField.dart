import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.contloller, required this.hintText});
  final String hintText;
  final TextEditingController contloller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: 282, // Set the height of the TextField container
      child: TextField(
        controller: contloller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10, // Adjusted to fit height
            horizontal: 12,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff988F8C),
              fontFamily: 'Segoe UI'),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Color(0xffE1E1E1), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(
              color: Color(0xffE1E1E1),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
