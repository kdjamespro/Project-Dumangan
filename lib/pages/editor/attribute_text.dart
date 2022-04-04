import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/pages/editor/draggable_text.dart';

class AttributeText extends ChangeNotifier {
  final List<String> attributeNames = [
    'Full Name',
    'Email',
    'Organization',
    'Event Name',
    'Event Date'
  ];
  Map<String, DraggableText> attributes;
  Function changeController;
  AttributeText({required this.changeController}) : attributes = Map();

  void addAttribute(String name) {
    attributes[name] = DraggableText(
      style: FontStyleController(
        controller: TextEditingController(text: '[' + name + ']'),
      ),
      focus: FocusNode(),
    );
    attributes[name]?.focus.addListener(() {
      bool? hasSelected = attributes[name]?.focus.hasFocus;
      if (hasSelected != null && hasSelected) {
        changeController(attributes[name]?.style);
      }
    });
    notifyListeners();
  }

  void hideIndicators() {
    if (attributes.isNotEmpty) {
      List<DraggableText> texts = attributes.values.toList();
      for (DraggableText text in texts) {
        text.hideIndicators();
      }
    }
  }

  void showIndicators() {
    if (attributes.isNotEmpty) {
      List<DraggableText> texts = attributes.values.toList();
      for (DraggableText text in texts) {
        text.showIndicators();
      }
    }
  }

  void removeAttribute(String name) {
    attributes.remove(name);
    notifyListeners();
  }

  Widget? getAttribute(String name) {
    return attributes[name];
  }
}
