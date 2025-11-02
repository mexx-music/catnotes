String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  // TODO: Heute/Morgen/Datum formatieren
  return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

