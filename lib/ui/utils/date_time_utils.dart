const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatDateShort(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}';
}

String formatDateLong(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}
