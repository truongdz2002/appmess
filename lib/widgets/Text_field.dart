import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool? toUpperCase ;
  const MyTextField({Key? key, required this.controller, required this.hintText, required this.obscureText,  this.toUpperCase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (value)
      {
        if(toUpperCase!)
          {
            if (value.isNotEmpty) {
              controller.value = controller.value.copyWith(
                text: value[0].toUpperCase() + value[0].substring(1),
                selection: TextSelection.collapsed(offset: value.length),
              );
            }
          }

      },
      decoration:InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        fillColor: Colors.grey[100],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black),
      //textCapitalization: TextCapitalization.words,
    );
  }
}
