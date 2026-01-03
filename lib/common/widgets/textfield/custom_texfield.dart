import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class CustomTexfield extends StatelessWidget {
  const CustomTexfield({super.key, required this.labelText, this.controller});

  final String labelText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        autofocus: true,
        autofillHints: const [AutofillHints.email],
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xFF57636C),
            fontSize: 16,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE0E3E7), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF4B39EF), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF5963), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF5963), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(18, 18, 0, 18),
        ),
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

@Preview(name: 'Custom TextField Preview')
Widget customListItemPreview() {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CustomTexfield(labelText: 'Email'),
  );
}
