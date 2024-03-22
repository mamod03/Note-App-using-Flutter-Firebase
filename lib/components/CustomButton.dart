import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  const CustomButton({super.key, this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color.fromARGB(255, 255, 174, 0),
      onPressed: onPressed,
      textColor: Colors.white,
      child: Text(title!),
    );
  }
}
