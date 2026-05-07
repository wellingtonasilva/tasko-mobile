import 'package:flutter/services.dart';

class BrPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    final formatted = _formatPhone(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatPhone(String digits) {
    if (digits.isEmpty) return '';

    final ddd = digits.length >= 2 ? digits.substring(0, 2) : digits;
    final rest = digits.length > 2 ? digits.substring(2) : '';

    if (rest.isEmpty) return '($ddd';
    if (rest.length <= 4) return '($ddd) $rest';

    // 10 dígitos: (11) 1234-5678
    if (digits.length <= 10) {
      final part1 = rest.substring(0, 4);
      final part2 = rest.substring(4);
      return part2.isEmpty ? '($ddd) $part1' : '($ddd) $part1-$part2';
    }

    // 11 dígitos: (11) 91234-5678
    final part1 = rest.substring(0, 5);
    final part2 = rest.substring(5);
    return part2.isEmpty ? '($ddd) $part1' : '($ddd) $part1-$part2';
  }
}
