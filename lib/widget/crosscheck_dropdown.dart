import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:provider/provider.dart';

import '/model/crosscheck_mapping.dart';

class CrossCheckDropDown extends StatefulWidget {
  final String column;
  const CrossCheckDropDown({Key? key, required this.column}) : super(key: key);

  @override
  State<CrossCheckDropDown> createState() => _CrossCheckDropDownState();
}

class _CrossCheckDropDownState extends State<CrossCheckDropDown> {
  String? value;

  @override
  Widget build(BuildContext context) {
    List<String> choices = ['Full Name', 'Email', 'Deselect'];
    return Combobox<String>(
      placeholder: const Text('Select Column Mapping'),
      items: choices.map((e) {
        if (e == 'Deselect') {
          return ComboboxItem<String>(
              value: e,
              child: Text(
                e,
                style: TextStyle(color: Colors.grey[100]),
              ));
        } else {
          return ComboboxItem<String>(value: e, child: Text(e));
        }
      }).toList(),
      value: value,
      onChanged: (val) {
        print(val);
        if (val != null) {
          CrossCheckMapping map =
              Provider.of<CrossCheckMapping>(context, listen: false);
          setState((() {
            if (val == 'Deselect') {
              map.removeAttribute(widget.column);
              value = null;
              return;
            } else if (!map.attributeExists(val)) {
              map.put(widget.column, val);
              value = val;
            } else {
              showWarningMessage(
                  context: context,
                  title: 'Attribute Mapping Error',
                  message: 'Attribute you selected already mapped to a column');
            }
          }));
        }
      },
    );
  }
}
