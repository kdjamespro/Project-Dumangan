import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/pages/editor/resizable_widget.dart';

class DraggableText extends StatefulWidget {
  const DraggableText({Key? key}) : super(key: key);

  @override
  _DraggableTextState createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  TextEditingController _controller = TextEditingController(text: "Add Text");
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EditableText(
            onEditingComplete: (() {}),
            cursorRadius: const Radius.circular(2.0),
            textInputAction: TextInputAction.done,
            scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
            scrollPhysics: const NeverScrollableScrollPhysics(),
            scrollController: null,
            controller: _controller,
            backgroundCursorColor: Colors.black,
            focusNode: _focusNode,
            maxLines: null,
            cursorColor: Colors.black,
            style: textStyle),
      ),
    );
  }
}

// Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: EditableText(
//           cursorRadius: Radius.circular(2.0),
//           textInputAction: TextInputAction.done,
//           scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
//           scrollPhysics: const NeverScrollableScrollPhysics(),
//           scrollController: null,
//           controller: _controller,
//           backgroundCursorColor: Colors.black,
//           focusNode: _focusNode,
//           maxLines: null,
//           cursorColor: Colors.black,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//           ),
//         ),
//       ),
