import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/indicator_controller.dart';

class ResizableWidget extends StatefulWidget {
  ResizableWidget({
    Key? key,
    required this.child,
    required this.focusNode,
    required this.indicatorController,
  }) : super(key: key);
  final Widget child;
  FocusNode focusNode;
  final IndicatorController indicatorController;

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

const ballDiameter = 7.0;

class _ResizableWidgetState extends State<ResizableWidget>
    with AutomaticKeepAliveClientMixin {
  late double height = 100;
  late double width = 150;

  double top = 100;
  double left = 100;
  late double initX;
  late double initY;

  late bool _isFocused;
  late var widgetKey = GlobalKey();
  late FocusNode focus;

  @override
  void initState() {
    focus = FocusNode();
    focus.addListener(() {
      setState(() {
        _isFocused = focus.hasFocus;
      });
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    updateHeight(newHeight, newWidth);
  }

  void updateHeight(double newHeight, double newWidth) {
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
    super.build(context);
    return Focus(
      focusNode: focus,
      child: Builder(builder: (BuildContext context) {
        final FocusNode focusNode = Focus.of(context);
        _isFocused = focusNode.hasFocus;
        return SizedBox(
          child: GestureDetector(
            // onTap: () {
            //   if (_isFocused) {
            //     focusNode.unfocus();
            //   } else {
            //     focusNode.requestFocus();
            //   }
            //   // setState(() {
            //   //   _isFocused = focusNode.hasFocus;
            //   // });
            // },
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
              alignment: const Alignment(0, 0),
              children: <Widget>[
                Positioned(
                  top: top + ballDiameter / 2,
                  left: left + ballDiameter / 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    height: height + ballDiameter / 2,
                    width: width + ballDiameter / 2,
                    child: widget.child,
                  ),
                ),
                // top left
                Positioned(
                  top: top - ballDiameter / 2,
                  left: left - ballDiameter / 2,
                  child: ManipulatingBall(
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
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
                    indicatorController: widget.indicatorController,
                    onDrag: (dx, dy) {
                      var newWidth = width - dx;

                      setState(() {
                        width = newWidth > 0 ? newWidth : 0;
                        left = left + dx;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall(
      {Key? key, required this.onDrag, required this.indicatorController})
      : super(key: key);

  final Function onDrag;
  final IndicatorController indicatorController;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;
  late IndicatorController controller;
  late bool showed;

  @override
  void initState() {
    controller = widget.indicatorController;
    showed = controller.isShowed;
    controller.addListener(() {
      setState(() {
        showed = controller.isShowed;
      });
    });
    super.initState();
  }

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
      visible: showed,
      child: GestureDetector(
        onPanStart: _handleDrag,
        onPanUpdate: _handleUpdate,
        child: Container(
          width: ballDiameter,
          height: ballDiameter,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
