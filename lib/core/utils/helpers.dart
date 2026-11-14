import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Helpers {
  static String price(num v) =>
      '${AppConstants.currency}${v == v.roundToDouble() ? v.round() : v.toStringAsFixed(2)}';

  static String todayLabel() => DateFormat('EEEE, d MMMM').format(DateTime.now());

  /// 8 PM se pehle true → aaj customize kar sakte ho (PDF §4.5)
  static bool customizationOpen() => DateTime.now().hour < AppConstants.customizationCutoffHour;

  static String mealSlot() {
    final h = DateTime.now().hour;
    if (h < 11) return 'breakfast';
    if (h < 16) return 'lunch';
    return 'dinner';
  }
}