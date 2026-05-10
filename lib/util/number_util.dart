class NumberUtil {
  static double parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) return 0;
    final sanitized = value.replaceAll(RegExp(r'[^0-9,\.]'), '').trim();
    final normalized = sanitized.contains(',') && sanitized.contains('.')
        ? sanitized.replaceAll('.', '').replaceAll(',', '.')
        : sanitized.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  static String? normalizeNullable(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
