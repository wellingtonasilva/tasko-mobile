String formatDate(DateTime? date) {
  if (date == null) return '';
  return '${date.day}/${date.month}/${date.year}';
}

String formatDateToBrazilian(DateTime? date) {
  if (date == null) return '';
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

DateTime? parseDate(String? date) {
  if (date == null || date.isEmpty) return null;
  try {
    return DateTime.parse(date);
  } catch (e) {
    return null;
  }
}

String formatDateTime(DateTime? date) {
  if (date == null) return '';
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

DateTime? parseDateTime(String? date) {
  if (date == null || date.isEmpty) return null;
  try {
    return DateTime.parse(date);
  } catch (e) {
    return null;
  }
}

String formatDateTimeToIso(DateTime? date) {
  if (date == null) return '';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
}
