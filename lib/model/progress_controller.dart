import 'package:fluent_ui/fluent_ui.dart';

class ProgressController extends ChangeNotifier {
  int progress = 0;
  int overall = 0;
  bool _isDisposed = false;

  ProgressController();

  void setOverall(int limit) {
    overall = limit;
  }

  void increase() {
    progress += 1;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void decrease() {
    progress -= 1;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void reset() {
    progress = 0;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
