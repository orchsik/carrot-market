import 'package:intl/intl.dart';

class DataUtils {
  static final oCcy = NumberFormat("#,###", "ko_KR");
  static String calcStringToWon(String priceString) {
    if (int.tryParse(priceString) != null) {
      return "${oCcy.format(double.parse(priceString))}원";
    } else {
      return "무료나눔";
    }
  }
}
