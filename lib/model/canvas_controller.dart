import 'package:flutter/cupertino.dart';

class CanvasController extends ChangeNotifier {
  double aspectRatio;
  PageOrientation orientation;
  int _selectedPageSize;
  int _selectedOrientation;
  CanvasController()
      : aspectRatio = PageOrientation.a4Landscape.aspecRatio,
        orientation = PageOrientation.a4Landscape,
        _selectedPageSize = 0,
        _selectedOrientation = 0;

  void changeSize(String type, String orientation) {
    if (type == 'A4') {
      _selectedPageSize = 0;
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.a4Landscape.aspecRatio;
        this.orientation = PageOrientation.a4Landscape;
        _selectedOrientation = 0;
      } else {
        aspectRatio = PageOrientation.a4Portrait.aspecRatio;
        this.orientation = PageOrientation.a4Portrait;
        _selectedOrientation = 1;
      }
    } else if (type == 'Legal') {
      _selectedPageSize = 1;
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.legalLandscape.aspecRatio;
        this.orientation = PageOrientation.legalLandscape;
        _selectedOrientation = 0;
      } else {
        aspectRatio = PageOrientation.legalPortrait.aspecRatio;
        this.orientation = PageOrientation.legalPortrait;
        _selectedOrientation = 1;
      }
    } else if (type == 'Letter') {
      _selectedPageSize = 2;
      if (orientation == 'Landscape') {
        aspectRatio = PageOrientation.letterLandscape.aspecRatio;
        this.orientation = PageOrientation.letterLandscape;
        _selectedOrientation = 0;
      } else {
        aspectRatio = PageOrientation.letterPortrait.aspecRatio;
        this.orientation = PageOrientation.letterPortrait;
        _selectedOrientation = 1;
      }
    }
    notifyListeners();
  }

  int get selectedPageSize => _selectedPageSize;
  int get selectedOrientation => _selectedOrientation;
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
  double get width {
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
  double get height {
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
