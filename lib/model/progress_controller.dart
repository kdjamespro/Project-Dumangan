import 'package:fluent_ui/fluent_ui.dart';

class ProgressController extends ChangeNotifier {
  int progress = 0;
  int overall = 0;

  ProgressController();

  void setOverall(int limit) {
    overall = limit;
  }

  void increase() {
    progress += 1;
    notifyListeners();
  }

  void decrease() {
    progress -= 1;
    notifyListeners();
  }

  void reset(){
    progress = 0;
  }
}
