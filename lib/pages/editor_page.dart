import 'package:fluent_ui/fluent_ui.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Demo());
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ResizebleWidget(
          child: Text(
            '''I've just did simple prototype to show main idea.
  1. Draw size handlers with container;
  2. Use GestureDetector to get new variables of sizes
  3. Refresh the main container size.''',
          ),
        ),
        ResizebleWidget(child: Text('Another Widget')),
      ],
    );
  }
}

class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({required this.child});
  final Widget child;

  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

const ballDiameter = 10.0;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  double height = 300;
  double width = 200;

  double top = 0;
  double left = 0;
  late double initX;
  late double initY;

  late bool _isFocused;

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (BuildContext context) {
        final FocusNode focusNode = Focus.of(context);
        _isFocused = focusNode.hasFocus;
        return GestureDetector(
          onTap: () {
            if (_isFocused) {
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
            setState(() {
              _isFocused = focusNode.hasFocus;
            });
          },
          onPanStart: _handleDrag,
          onPanUpdate: (details) {
            var dx = details.globalPosition.dx - initX;
            var dy = details.globalPosition.dy - initY;
            initX = details.globalPosition.dx;
            initY = details.globalPosition.dy;
            setState(() {
              top = top + dy;
              left = left + dx;
            });
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                top: top,
                left: left,
                child: Container(
                  height: height,
                  width: width,
                  child: widget.child,
                ),
              ),
              // top left
              Positioned(
                top: top - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var mid = (dx + dy) / 2;
                    var newHeight = height - 2 * mid;
                    var newWidth = width - 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top + mid;
                      left = left + mid;
                    });
                  },
                ),
              ),
              // top middle
              Positioned(
                top: top - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var newHeight = height - dy;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      top = top + dy;
                    });
                  },
                ),
              ),
              // top right
              Positioned(
                top: top - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var mid = (dx + (dy * -1)) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top - mid;
                      left = left - mid;
                    });
                  },
                ),
              ),
              // center right
              Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var newWidth = width + dx;

                    setState(() {
                      width = newWidth > 0 ? newWidth : 0;
                    });
                  },
                ),
              ),
              // bottom right
              Positioned(
                top: top + height - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var mid = (dx + dy) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top - mid;
                      left = left - mid;
                    });
                  },
                ),
              ),
              // bottom center
              Positioned(
                top: top + height - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var newHeight = height + dy;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                    });
                  },
                ),
              ),
              // bottom left
              Positioned(
                top: top + height - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var mid = ((dx * -1) + dy) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top - mid;
                      left = left - mid;
                    });
                  },
                ),
              ),
              //left center
              Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  focus: _isFocused,
                  onDrag: (dx, dy) {
                    var newWidth = width - dx;

                    setState(() {
                      width = newWidth > 0 ? newWidth : 0;
                      left = left + dx;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key? key, required this.onDrag, required this.focus});

  final Function onDrag;
  bool focus = false;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.focus,
      child: GestureDetector(
        onPanStart: _handleDrag,
        onPanUpdate: _handleUpdate,
        child: Container(
          width: ballDiameter,
          height: ballDiameter,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
