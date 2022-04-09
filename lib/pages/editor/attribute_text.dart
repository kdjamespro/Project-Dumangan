import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/model/selected_event.dart';
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
  late Function changeController;
  Map<String, List<String>> dynamicFieldData;
  int size = 0;
  List<int> _participantIds;

  AttributeText()
      : attributes = {},
        dynamicFieldData = {},
        _participantIds = [];

  void setChangeController(Function changer) {
    changeController = changer;
  }

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

  void setDynamicFieldsData(
    List<ParticipantsTableData> participantsInfo,
    SelectedEvent event,
  ) {
    size = participantsInfo.length;
    List<String> attr = _getUsedAttributes();
    List<String> participantsAttr = _getUsedParticipantAttribute(attr);
    attr.removeWhere((element) => participantsAttr.contains(element));
    _setParticipantsData(participantsInfo, participantsAttr);
    _setEventsData(event, attr);
  }

  int updateAttributes(int index) {
    if (index < size) {
      for (String field in dynamicFieldData.keys) {
        attributes[field]?.style.controller.text =
            dynamicFieldData[field]?.elementAt(index) ?? '';
      }
      int participantsId = _participantIds[index];
      notifyListeners();
      return participantsId;
    }
    return -1;
  }

  void _setParticipantsData(List<ParticipantsTableData> participantsInfo,
      List<String> participantsAttr) {
    List<List<String>> data =
        List.generate(participantsAttr.length, (index) => []);
    for (ParticipantsTableData participants in participantsInfo) {
      _participantIds.add(participants.id);
      for (int i = 0; i < participantsAttr.length; i++) {
        if (participantsAttr[i] == 'Full Name') {
          data[i].add(participants.fullName);
        } else if (participantsAttr[i] == 'Email') {
          data[i].add(participants.email);
        } else if (participantsAttr[i] == 'Organization') {
          data[i].add(participants.organization ?? '');
        }
      }
    }

    for (int i = 0; i < participantsAttr.length; i++) {
      dynamicFieldData[participantsAttr[i]] = data[i];
    }
  }

  void _setEventsData(SelectedEvent event, List<String> attr) {
    for (String eventAttribute in attr) {
      if (eventAttribute == 'Event Name') {
        attributes[eventAttribute]?.style.controller.text = event.eventName;
      } else if (eventAttribute == 'Event Date') {
        attributes[eventAttribute]?.style.controller.text = event.eventDate;
      }
    }
    notifyListeners();
  }

  List<String> _getUsedParticipantAttribute(List<String> list) {
    List<String> copy = List.from(list);
    if (copy.isNotEmpty) {
      copy.retainWhere((element) =>
          element == 'Full Name' ||
          element == 'Email' ||
          element == 'Organization');
      return copy;
    }
    return [];
  }

  List<String> _getUsedAttributes() {
    if (attributes.isNotEmpty) {
      return attributes.keys.toList();
    }
    return [];
  }

  void reset() {
    if (attributes.isNotEmpty) {
      for (var key in attributes.keys) {
        attributes[key]?.style.controller.text = '[' + key + ']';
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
