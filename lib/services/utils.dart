import 'package:intl/intl.dart ';

class Utils {
  static String dateValidator(String? value) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');
    final String formatted = formatter.format(now);
    if (value == null) {
      value = '';
    }
    String str1 = value;
    List<String> str2 = str1.split('/');
    String month = str2.isNotEmpty ? str2[0] : '';
    String day = str2.length > 1 ? str2[1] : '';
    String year = str2.length > 2 ? str2[2] : '';
    if (value.isEmpty) {
      return 'Date is Empty';
    } else if (int.parse(month) > 13) {
      return 'Month is invalid';
    } else if (int.parse(day) > 32) {
      return 'Day is invalid';
    } else if ((int.parse(year) > int.parse(formatted))) {
      return 'Year is invalid';
    } else if ((int.parse(year) < 1920)) {
      return 'Year is invalid';
    }
    return '';
  }
}
