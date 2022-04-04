import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/model/indicator_controller.dart';
import 'package:project_dumangan/pages/editor/resizable_widget.dart';

class DraggableText extends StatefulWidget {
  DraggableText({Key? key, required this.style, required this.focus})
      : indicatorController = IndicatorController(),
        super(key: key);
  final FontStyleController style;
  final FocusNode focus;
  final IndicatorController indicatorController;
  void hideIndicators() {
    indicatorController.hideIndicator();
  }

  void showIndicators() {
    indicatorController.showIndicator();
  }

  @override
  _DraggableTextState createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late FontStyleController styleController;
  late TextStyle style;
  late TextAlign alignment;

  @override
  void initState() {
    _focusNode = widget.focus;
    styleController = widget.style;
    _controller = widget.style.controller;
    style = styleController.textStyle;
    alignment = styleController.alignment;
    styleController.addListener(() {
      setState(() {
        style = styleController.textStyle;
        alignment = styleController.alignment;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResizableWidget(
      indicatorController: widget.indicatorController,
      focusNode: _focusNode,
      child: Center(
        child: Align(
          //Here
          alignment: Alignment.center,
          child: EditableText(
            readOnly: true,
            backgroundCursorColor: Colors.black,
            onEditingComplete: (() {}),
            cursorRadius: const Radius.circular(1.0),
            textInputAction: TextInputAction.done,
            scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
            scrollPhysics: const NeverScrollableScrollPhysics(),
            scrollController: null,
            controller: _controller,
            focusNode: _focusNode,
            maxLines: null,
            cursorColor: Colors.black,
            textAlign: alignment,
            style: style,
          ),
        ),
      ),
    );
  }

  Align buildEditableText(String styleFontStyle, String styleFontSize) {
    return Align(
      //Here
      alignment: Alignment.center,
      child: EditableText(
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
        textAlign: TextAlign.center,
        style: widget.style.textStyle,
      ),
    );
  }
}
