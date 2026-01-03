import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class CustomTextFieldLarge extends StatelessWidget {
  CustomTextFieldLarge({super.key, required this.labelText, this.controller});

  final String labelText;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      //focusNode: _model.fullNameFocusNode,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      obscureText: false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Outfit',
          color: Color(0xFF606A85),
          fontSize: 24,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Outfit',
          color: Color(0xFF606A85),
          fontSize: 14,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Figtree',
          color: Color(0xFFFF5963),
          fontSize: 12,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6F61EF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF5963), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF5963), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        //fillColor: (_model.fullNameFocusNode?.hasFocus ?? false)
        //    ? const Color(0x4D9489F5)
        //    : Colors.white,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
      ),
      style: const TextStyle(
        fontFamily: 'Outfit',
        color: Color(0xFF15161E),
        fontSize: 24,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: const Color(0xFF6F61EF),
      //validator: _model.fullNameTextControllerValidator.asValidator(context),
    );
  }
}

@Preview(name: 'Custom TextField Large Preview')
Widget customTextFieldLargePreview() {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: CustomTextFieldLarge(labelText: 'Full Name'),
  );
}
