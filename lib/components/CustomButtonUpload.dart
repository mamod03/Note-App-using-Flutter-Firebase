import 'package:flutter/material.dart';

class CustomButtonUpload extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  final bool isSelected;
  const CustomButtonUpload(
      {super.key, this.onPressed, this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 35,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected ? Colors.green : Color.fromARGB(255, 255, 174, 0),
      onPressed: onPressed,
      textColor: Colors.white,
      child: Text(title!),
    );
  }
}
