import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/pages/editor/draggable_text.dart';

class AttributeText {
  final List attributeNames = [
    'Particpant\'s Full Name',
    'Particpant\'s Email',
    'Particpant\'s Organization'
  ];
  Map<String, DraggableText> attributes;
  Function changeController;
  AttributeText({required this.changeController}) : attributes = Map();

  void addAttribute(String name) {
    attributes[name] = DraggableText(
      style: FontStyleController(
        controller: TextEditingController(text: name),
      ),
      focus: FocusNode(),
    );
    attributes[name]?.focus.addListener(() {
      bool? hasSelected = attributes[name]?.focus.hasFocus;
      if (hasSelected != null && hasSelected) {
        changeController(attributes[name]?.style);
      }
    });
  }

  Widget? getAttribute(String name) {
    return attributes[name];
  }
}
