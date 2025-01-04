extension DoubleExtension on double {
  String formatNumber() {
    if (abs() >= 1e15) {
      return '${(this / 1e15).toStringAsFixed(1)}Q'; // Quadrillion
    }
    if (abs() >= 1e12) {
      return '${(this / 1e12).toStringAsFixed(1)}T'; // Trillion
    }
    if (abs() >= 1e9) return '${(this / 1e9).toStringAsFixed(1)}B'; // Billion
    if (abs() >= 1e6) return '${(this / 1e6).toStringAsFixed(1)}M'; // Million
    if (abs() >= 1e3) return '${(this / 1e3).toStringAsFixed(1)}K'; // Thousand
    return toStringAsFixed(
        this == toInt() ? 0 : 2); // Show decimals only if needed
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
