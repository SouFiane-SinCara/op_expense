extension DoubleExtension on double {
  String toFormattedBalance() {
    return (this > 0 ? '+' : '') +
        (toInt() == this ? toInt().toString() : toString());
  }
}

extension StringExtension on String {
  int durationToNumber() {
    switch (this) {
      case 'Today':
        return 1;
      case 'Week':
        return 7;
      case 'Month':
        return 30;
      case 'Year':
        return 365;
      default:
        return 0;
    }
  }
}
