// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget 
{
  final String? hint;
  final TextEditingController? controller;

  MyTextField({this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        //if the value is empty, it'll display text showing this field shouldn't be empty, else null i.e. user need to write something.
        validator: (value) => value!.isEmpty ? "Field cannot be empty." : null,
      ),
    );
  }
}