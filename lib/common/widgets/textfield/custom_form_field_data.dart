import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomFormFieldData {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? labelText;
  final String? Function(BuildContext, String?)? validator;
  final Widget? prefixIcon;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  CustomFormFieldData({
    required this.controller,
    required this.focusNode,
    required this.labelText,
    this.validator,
    this.prefixIcon,
    this.hintText,
    this.inputFormatters,
    this.keyboardType,
  });
}
