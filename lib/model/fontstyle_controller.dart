import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyleController extends ChangeNotifier {
  TextAlign alignment = TextAlign.center;
  TextStyle textStyle = const TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontFamily: 'Roboto',
  );
  String _fontFamily = 'Roboto';

  late TextEditingController controller;

  FontStyleController({required this.controller});

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void changeText(String text) {
    controller.text = text;
    notifyListeners();
  }

  void changeFontStyle(String selectedFamily, TextStyle style) {
    textStyle = GoogleFonts.getFont(
      selectedFamily,
      textStyle: textStyle.copyWith(
          fontFamily: selectedFamily,
          fontWeight: style.fontWeight,
          fontStyle: style.fontStyle),
    );
    _fontFamily = selectedFamily;
    notifyListeners();
  }

  void changeFontSize(double size) {
    textStyle = textStyle.copyWith(fontSize: size);
    notifyListeners();
  }

  void changeFontColor(Color selected) {
    textStyle = textStyle.copyWith(color: selected);
    notifyListeners();
  }

  void changeFontWeight(String weight) {
    if (weight == "Thin") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w100);
    } else if (weight == "Light") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w300);
    } else if (weight == "Regular") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w400);
    } else if (weight == "Medium") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w500);
    } else if (weight == "SemiBold") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w600);
    } else if (weight == "Bold") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w700);
    } else if (weight == "ExtraBold") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w800);
    } else if (weight == "Black") {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w900);
    }

    notifyListeners();
  }

  String get fontFamily => _fontFamily;

  void changeFontAlignment(TextAlign selected) {
    alignment = selected;
    notifyListeners();
  }
}
