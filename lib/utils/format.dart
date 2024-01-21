String toFullVnDateTime(DateTime time) {
  return "${time.day} Th${time.month}, ${time.year}";
}

String toFullVnTimeStamp(DateTime time) {
  return "${time.day} Th${time.month}, ${time.year} ${time.hour}:${time.minute}";
}

String toVnMonthYear(DateTime time) {
  return "Th${time.month} ${time.year}";
}
