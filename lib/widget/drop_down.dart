import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:provider/provider.dart';

class DropDownMapping extends StatefulWidget {
  final String column;
  DropDownMapping({Key? key, required this.column}) : super(key: key);

  @override
  State<DropDownMapping> createState() => _DropDownMappingState();
}

class _DropDownMappingState extends State<DropDownMapping> {
  String? value;

  @override
  Widget build(BuildContext context) {
    List<String> choices = ['Full Name', 'Email', 'Organization', 'Deselect'];
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
          AttributeMapping map =
              Provider.of<AttributeMapping>(context, listen: false);
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
