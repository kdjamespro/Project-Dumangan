import 'package:fluent_ui/fluent_ui.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  late TextEditingController _fontSize;
  int selected = 16;

  @override
  void initState() {
    _fontSize = TextEditingController(text: "16");
    super.initState();
  }

  @override
  void dispose() {
    _fontSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final values = <int>[for (var i = 7; i <= 30; i++) i];
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Combobox<int>(
            onChanged: (val) => setState(() => selected = val as int),
            selectedItemBuilder: (BuildContext context) {
              return values.map<Widget>((int val) {
                return Text('$val');
              }).toList();
            },
            items: values
                .map((int val) =>
                    ComboboxItem<int>(value: val, child: Text('$val')))
                .toList(),
            value: selected,
          ),
        )
      ],
    );
  }
}
