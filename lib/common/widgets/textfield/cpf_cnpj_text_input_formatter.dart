import 'package:flutter/services.dart';

class CpfCnpjTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = format(newValue.text);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String format(String value) {
    var digits = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length > 14) {
      digits = digits.substring(0, 14);
    }

    if (digits.length <= 11) {
      return _formatCpf(digits);
    }

    return _formatCnpj(digits);
  }

  String _formatCpf(String digits) {
    if (digits.length <= 3) {
      return digits;
    }

    if (digits.length <= 6) {
      return '${digits.substring(0, 3)}.${digits.substring(3)}';
    }

    if (digits.length <= 9) {
      return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6)}';
    }

    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
  }

  String _formatCnpj(String digits) {
    if (digits.length <= 2) {
      return digits;
    }

    if (digits.length <= 5) {
      return '${digits.substring(0, 2)}.${digits.substring(2)}';
    }

    if (digits.length <= 8) {
      return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5)}';
    }

    if (digits.length <= 12) {
      return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8)}';
    }

    return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12)}';
  }
}
