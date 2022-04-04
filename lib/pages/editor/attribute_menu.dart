import 'package:fluent_ui/fluent_ui.dart';

class AttributeMenu extends StatefulWidget {
  const AttributeMenu({Key? key}) : super(key: key);

  @override
  State<AttributeMenu> createState() => _AttributeMenuState();
}

class _AttributeMenuState extends State<AttributeMenu> {
  bool activated = false;
  String text = 'Use';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(child: const Text('Name')),
              const Spacer(),
              ToggleButton(
                child: Text(text),
                onChanged: (checked) {
                  setState(() {
                    activated = checked;
                    if (activated) {
                      text = 'Disable';
                    } else {
                      text = 'Use';
                    }
                  });
                },
                checked: activated,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
