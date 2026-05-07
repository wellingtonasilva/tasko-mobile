import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalTextInputFormatter({this.decimalDigits = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final value = int.parse(digits) / math.pow(10, decimalDigits);
    final formatted = NumberFormat.decimalPatternDigits(
      locale: 'pt_BR',
      decimalDigits: decimalDigits,
    ).format(value);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
