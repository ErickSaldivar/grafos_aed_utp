import 'package:flutter/material.dart';

class TextFieldCosto extends StatelessWidget {
  const TextFieldCosto({
    super.key,
    required this.controller,
    required this.ciudad,
  });

  final TextEditingController controller;
  final String ciudad;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: ciudad,
          hintText: '\$ 0.00',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
