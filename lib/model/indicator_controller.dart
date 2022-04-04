import 'package:flutter/cupertino.dart';

class IndicatorController extends ChangeNotifier {
  bool _isShowed;
  IndicatorController() : _isShowed = true;

  void hideIndicator() {
    _isShowed = false;
    notifyListeners();
  }

  void showIndicator() {
    _isShowed = true;
    notifyListeners();
  }

  bool get isShowed => _isShowed;
}
