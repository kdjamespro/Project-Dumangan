import 'package:fluent_ui/fluent_ui.dart';

class MenuButton extends StatefulWidget {
  MenuButton(
      {Key? key,
      required this.onPress,
      required this.menuIcon,
      required this.label,
      required this.color})
      : super(key: key);
  final Function() onPress;
  final Icon menuIcon;
  final String label;
  Color? color;
  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: IconButton(
        onPressed: widget.onPress,
        icon: Column(
          children: [
            widget.menuIcon,
            Text(
              widget.label,
              style: FluentTheme.of(context).typography.caption,
            ),
          ],
        ),
      ),
    );
  }
}
