import 'package:fluent_ui/fluent_ui.dart';

import 'attribute_text.dart';

class AttributeMenu extends StatefulWidget {
  const AttributeMenu({Key? key, required, required this.attributes})
      : super(key: key);
  final AttributeText attributes;
  @override
  State<AttributeMenu> createState() => _AttributeMenuState();
}

class _AttributeMenuState extends State<AttributeMenu> {
  late List<String> attributes;
  late List<String> buttonText;
  late List<bool> activated;
  @override
  void initState() {
    attributes = widget.attributes.attributeNames;
    List<String> selectedAttributes =
        widget.attributes.attributes.keys.toList();
    buttonText = List<String>.filled(attributes.length, 'Use');
    activated = List<bool>.filled(attributes.length, false);
    for (int i = 0; i < attributes.length; i++) {
      if (selectedAttributes.contains(attributes[i])) {
        buttonText[i] = 'Disable';
        activated[i] = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          ...List.generate(
            attributes.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(child: Text(attributes[index])),
                  const Spacer(),
                  ToggleButton(
                    child: Text(buttonText[index]),
                    onChanged: (checked) {
                      setState(() {
                        activated[index] = checked;
                        if (activated[index]) {
                          widget.attributes.addAttribute(attributes[index]);
                          buttonText[index] = 'Disable';
                        } else {
                          widget.attributes.removeAttribute(attributes[index]);
                          buttonText[index] = 'Use';
                        }
                      });
                    },
                    checked: activated[index],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
