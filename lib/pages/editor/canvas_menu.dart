import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/canvas_controller.dart';

class CanvasMenu extends StatefulWidget {
  final CanvasController controller;

  const CanvasMenu({Key? key, required this.controller}) : super(key: key);

  @override
  State<CanvasMenu> createState() => _CanvasMenuState();
}

class _CanvasMenuState extends State<CanvasMenu>
    with AutomaticKeepAliveClientMixin {
  late CanvasController page;
  int _selectedPageSize = 0;
  int _selectedOrientation = 0;
  final List<String> pageSize = ['A4', 'Legal', 'Letter'];
  final List<String> orientation = ['Landscape', 'Portrait'];

  @override
  void initState() {
    page = widget.controller;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Flexible(
          child: Text('Page Size: '),
        ),
        const SizedBox(height: 5),
        Row(
          children: List.generate(pageSize.length, (index) {
            return Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: RadioButton(
                checked: _selectedPageSize == index,
                onChanged: (toggle) {
                  setState(() => _selectedPageSize = index);
                  page.changeSize(pageSize[_selectedPageSize],
                      orientation[_selectedOrientation]);
                },
                content: Text(pageSize[index]),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        const Flexible(
          child: Text('Orientation: '),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(orientation.length, (index) {
            return Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: RadioButton(
                checked: _selectedOrientation == index,
                onChanged: (toggle) {
                  setState(() => _selectedOrientation = index);
                  page.changeSize(pageSize[_selectedPageSize],
                      orientation[_selectedOrientation]);
                },
                content: Text(orientation[index]),
              ),
            );
          }),
        ),
      ],
    );
  }
}
