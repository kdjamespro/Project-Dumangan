import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/pages/editor/resizable_widget.dart';

class DraggableText extends StatefulWidget {
  const DraggableText({Key? key}) : super(key: key);

  @override
  _DraggableTextState createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  TextEditingController _controller =
      TextEditingController(text: "Sample Name");
  late FocusNode _focusNode;
  TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResizableWidget(
      focusNode: _focusNode,
      child: Center(
        child: buildEditableText("", ""),
      ),
    );
  }

  EditableText buildEditableText(String styleFontStyle, String styleFontSize) {
    return EditableText(
      onEditingComplete: (() {}),
      cursorRadius: const Radius.circular(1.0),
      textInputAction: TextInputAction.done,
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
      scrollPhysics: const NeverScrollableScrollPhysics(),
      scrollController: null,
      controller: _controller,
      backgroundCursorColor: Colors.black,
      focusNode: _focusNode,
      maxLines: null,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }
}
