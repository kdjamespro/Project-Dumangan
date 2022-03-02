import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;

String fontSelector = "Calibri";
String fontViewer = "";

class FontPicker extends StatefulWidget {
  const FontPicker({Key? key}) : super(key: key);

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  List<String> fonts = ['Baskerville', 'Calibri', 'SweetChild', 'OldEnglish'];

  Container FontChanger(font, style) {
    final String fontTitle = font;
    final String styleFont = style;
    return Container(
      child: mat.OutlinedButton(
        style: mat.OutlinedButton.styleFrom(
            side: const BorderSide(color: mat.Colors.white, width: 400),
            padding: const EdgeInsets.fromLTRB(5, 0, 120, 10)),
        child: Text(
          fontTitle,
          style: TextStyle(color: mat.Colors.black, fontFamily: styleFont),
        ),
        onPressed: () {
          setState(() {
            fontSelector = fontTitle;
            fontViewer = styleFont;
            print(fontSelector);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expander(
      header: Text("$fontSelector"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FontButton(
          //   fontTitle: 'Baskerville',
          //   styleFont: "Baskerville",
          // ),
          // FontButton(
          //   fontTitle: 'Calibri',
          //   styleFont: "Calibri",
          // ),
          // FontButton(
          //   fontTitle: 'Sweet Child',
          //   styleFont: "SweetChild",
          // ),
          // FontButton(
          //   fontTitle: 'Old English',
          //   styleFont: "OldEnglish",
          // ),
          // Container(
          //   child: mat.OutlinedButton(
          //     style: mat.OutlinedButton.styleFrom(
          //         side: BorderSide(
          //             color: mat.Colors.white, width: 400),
          //         padding:
          //             EdgeInsets.fromLTRB(5, 0, 120, 10)),
          //     child: Text(
          //       "Inline 1",
          //       style: TextStyle(color: mat.Colors.black),
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         fontSelector = "Inline 1";
          //         print("Clicked");
          //       });
          //     },
          //   ),
          // ),
          FontChanger("Basekerville", "Baskerville"),
          FontChanger("Calibri", "Calibri"),
          FontChanger("Sweet Child", "SweetChild"),
          FontChanger("Old English", "OldEnglish"),

          //
          // NewWidget(
          //   fontTitle: "Baskerville",
          //   styleFont: "Baskerville",
          // ),
        ],
      ),
      direction: ExpanderDirection
          .down, // (optional). Defaults to ExpanderDirection.down
      initiallyExpanded: false, // (false). Defaults to false
    );
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    Key? key,
    required this.fontTitle,
    required this.styleFont,
  }) : super(key: key);
  final String fontTitle;
  final String styleFont;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: mat.OutlinedButton(
        style: mat.OutlinedButton.styleFrom(
            side: const BorderSide(color: mat.Colors.white, width: 400),
            padding: const EdgeInsets.fromLTRB(5, 0, 120, 10)),
        child: Text(
          widget.fontTitle,
          style:
              TextStyle(color: mat.Colors.black, fontFamily: widget.styleFont),
        ),
        onPressed: () {
          setState(() {
            String ako = widget.fontTitle;
            fontSelector = ako;
            print(ako);
          });
        },
      ),
    );
  }
}

class FontButton extends StatefulWidget {
  const FontButton({
    Key? key,
    required this.fontTitle,
    required this.styleFont,
  }) : super(key: key);
  final String fontTitle;
  final String styleFont;

  @override
  State<FontButton> createState() => _FontButtonState();
}

class _FontButtonState extends State<FontButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          fontSelector = (widget.fontTitle).toString();
        });
      },
      child: mat.OutlinedButton(
        style: mat.OutlinedButton.styleFrom(
            side: BorderSide(color: mat.Colors.white, width: 400),
            padding: EdgeInsets.fromLTRB(5, 0, 120, 10)),
        child: Text(
          widget.fontTitle,
          style:
              TextStyle(fontFamily: widget.styleFont, color: mat.Colors.black),
        ),
        onPressed: () {
          setState(() {
            fontSelector = (widget.fontTitle).toString();
            print(widget.fontTitle);
          });
        },
      ),
    );
  }
}
