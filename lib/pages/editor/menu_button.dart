import 'package:fluent_ui/fluent_ui.dart';

class MenuButton extends StatefulWidget {
  const MenuButton(
      {Key? key,
      required this.onPress,
      required this.menuIcon,
      required this.label})
      : super(key: key);
  final Function() onPress;
  final Icon menuIcon;
  final String label;
  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected
          ? FluentTheme.of(context).accentColor.lightest.withOpacity(0.8)
          : null,
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
