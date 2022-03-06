import 'package:fluent_ui/fluent_ui.dart';

class FontStyleController with ChangeNotifier {
  TextStyle _textStyle = const TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: 'Calibri',
  );

  TextStyle get textStyle => _textStyle;

  void changeFontStyle(TextStyle style) {
    _textStyle = style;
    notifyListeners();
  }
}
