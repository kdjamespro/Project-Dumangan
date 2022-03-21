import 'package:flutter/cupertino.dart';

class CanvasController extends ChangeNotifier {
  double aspectRatio;
  CanvasController() : aspectRatio = PageOrientation.a4Landscape.size;

  void changeSize(String type, String orientation) {
    if (type == 'A4') {
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.a4Landscape.size;
      } else {
        aspectRatio = PageOrientation.a4Portrait.size;
      }
    } else if (type == 'Legal') {
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.legalLandscape.size;
      } else {
        aspectRatio = PageOrientation.legalPortrait.size;
      }
    } else if (type == 'Letter') {
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.letterLandscape.size;
      } else {
        aspectRatio = PageOrientation.letterPortrait.size;
      }
    }

    notifyListeners();
  }
}

enum PageOrientation {
  a4Landscape,
  a4Portrait,
  legalPortrait,
  legalLandscape,
  letterPortrait,
  letterLandscape,
}

extension PageOrientationExtension on PageOrientation {
  double get size {
    switch (this) {
      case PageOrientation.a4Portrait:
        return 1 / 1.4142;
      case PageOrientation.legalPortrait:
        return 1 / 1.6471;
      case PageOrientation.legalLandscape:
        return 1.6471 / 1;
      case PageOrientation.letterPortrait:
        return 1 / 1.2941;
      case PageOrientation.letterLandscape:
        return 1.2941 / 1;
      case PageOrientation.a4Landscape:
      default:
        return 1.4142 / 1;
    }
  }
}
