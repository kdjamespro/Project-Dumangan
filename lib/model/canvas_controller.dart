import 'package:flutter/cupertino.dart';

class CanvasController extends ChangeNotifier {
  double aspectRatio;
  PageOrientation orientation;
  CanvasController()
      : aspectRatio = PageOrientation.a4Landscape.aspecRatio,
        orientation = PageOrientation.a4Landscape;

  void changeSize(String type, String orientation) {
    if (type == 'A4') {
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.a4Landscape.aspecRatio;
        this.orientation = PageOrientation.a4Landscape;
      } else {
        aspectRatio = PageOrientation.a4Portrait.aspecRatio;
        this.orientation = PageOrientation.a4Portrait;
      }
    } else if (type == 'Legal') {
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.legalLandscape.aspecRatio;
        this.orientation = PageOrientation.legalLandscape;
      } else {
        aspectRatio = PageOrientation.legalPortrait.aspecRatio;
        this.orientation = PageOrientation.legalPortrait;
      }
    } else if (type == 'Letter') {
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.letterLandscape.aspecRatio;
        this.orientation = PageOrientation.letterLandscape;
      } else {
        aspectRatio = PageOrientation.letterPortrait.aspecRatio;
        this.orientation = PageOrientation.letterPortrait;
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
  double get aspecRatio {
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

extension PageOrientationWidth on PageOrientation {
  int get width {
    switch (this) {
      case PageOrientation.legalPortrait:
        return 2551;
      case PageOrientation.legalLandscape:
        return 4205;
      case PageOrientation.letterPortrait:
        return 2551;
      case PageOrientation.letterLandscape:
        return 3295;
      case PageOrientation.a4Landscape:
        return 3508;
      case PageOrientation.a4Portrait:
      default:
        return 2480;
    }
  }
}

extension PageOrientationHeight on PageOrientation {
  int get height {
    switch (this) {
      case PageOrientation.legalPortrait:
        return 4205;
      case PageOrientation.legalLandscape:
        return 2551;
      case PageOrientation.letterPortrait:
        return 3295;
      case PageOrientation.letterLandscape:
        return 2551;
      case PageOrientation.a4Landscape:
        return 2480;
      case PageOrientation.a4Portrait:
      default:
        return 3508;
    }
  }
}
