import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:project_dumangan/model/draggable_controller.dart';
import 'package:project_dumangan/model/indicator_controller.dart';

class ResizableWidget extends StatefulWidget {
  ResizableWidget({
    Key? key,
    required this.child,
    required this.focusNode,
    required this.indicatorController,
    required this.drag,
  }) : super(key: key);
  final Widget child;
  FocusNode focusNode;
  final IndicatorController indicatorController;
  final DraggableController drag;
  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

const ballDiameter = 7.0;

class _ResizableWidgetState extends State<ResizableWidget>
    with AutomaticKeepAliveClientMixin<ResizableWidget> {
  late double top;
  late double left;
  late double height;
  late double width;
  late double initX;
  late double initY;
  late bool _isFocused;

  @override
  void initState() {
    top = widget.drag.top;
    left = widget.drag.left;
    height = widget.drag.height;
    width = widget.drag.width;

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
      widget.drag.height = height;
      widget.drag.width = width;
    });
  }

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
      widget.drag.initX = initX;
      widget.drag.initY = initY;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Focus(
      child: Builder(builder: (BuildContext context) {
        final FocusNode focusNode = Focus.of(context);
        _isFocused = focusNode.hasFocus;
        return GestureDetector(
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
          // onPanStart: _handleDrag,
          // onPanUpdate: (details) {
          //   var dx = details.globalPosition.dx - initX;
          //   var dy = details.globalPosition.dy - initY;
          //   initX = details.globalPosition.dx;
          //   initY = details.globalPosition.dy;
          //   setState(() {
          //     top = top + dy;
          //     left = left + dx;
          //     widget.drag.top = top;
          //     widget.drag.left = left;
          //   });
          // },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: <Widget>[
              Positioned(
                top: top + ballDiameter / 2,
                left: left + ballDiameter / 2,
                child: GestureDetector(
                  onPanStart: _handleDrag,
                  onPanUpdate: (details) {
                    var dx = details.globalPosition.dx - initX;
                    var dy = details.globalPosition.dy - initY;
                    initX = details.globalPosition.dx;
                    initY = details.globalPosition.dy;
                    setState(() {
                      top = top + dy;
                      left = left + dx;
                      widget.drag.top = top;
                      widget.drag.left = left;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    height: height + ballDiameter / 2,
                    width: width + ballDiameter / 2,
                    child: widget.child,
                  ),
                ),
              ),
              // top left
              Positioned(
                top: top - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'top left',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var mid = (dx + dy) / 2;
                    var newHeight = height - 2 * mid;
                    var newWidth = width - 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      widget.drag.height = height;
                      widget.drag.width = width;
                      top = top + mid;
                      left = left + mid;
                      widget.drag.top = top;
                      widget.drag.left = left;
                    });
                  },
                ),
              ),
              // top middle
              Positioned(
                top: top - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'top center',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var newHeight = height - dy;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      widget.drag.height = height;
                      top = top + dy;
                      widget.drag.top = top;
                    });
                  },
                ),
              ),
              // top right
              Positioned(
                top: top - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'top right',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var mid = (dx + (dy * -1)) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      widget.drag.height = height;
                      widget.drag.width = width;
                      top = top - mid;
                      left = left - mid;
                      widget.drag.top = top;
                      widget.drag.left = left;
                    });
                  },
                ),
              ),
              // center right
              Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'center right',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var newWidth = width + dx;

                    setState(() {
                      width = newWidth > 0 ? newWidth : 0;
                      widget.drag.width = width;
                    });
                  },
                ),
              ),
              // bottom right
              Positioned(
                top: top + height - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'bottom right',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var mid = (dx + dy) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      widget.drag.height = height;
                      widget.drag.width = width;
                      top = top - mid;
                      left = left - mid;
                      widget.drag.top = top;
                      widget.drag.left = left;
                    });
                  },
                ),
              ),
              // bottom center
              Positioned(
                top: top + height - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'bottom center',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var newHeight = height + dy;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      widget.drag.height = height;
                    });
                  },
                ),
              ),
              // bottom left
              Positioned(
                top: top + height - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'bottom left',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var mid = ((dx * -1) + dy) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      widget.drag.height = height;
                      widget.drag.width = width;
                      top = top - mid;
                      left = left - mid;
                      widget.drag.top = top;
                      widget.drag.left = left;
                    });
                  },
                ),
              ),
              //left center
              Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  location: 'center left',
                  drag: widget.drag,
                  indicatorController: widget.indicatorController,
                  onDrag: (dx, dy) {
                    var newWidth = width - dx;

                    setState(() {
                      width = newWidth > 0 ? newWidth : 0;
                      widget.drag.width = width;
                      left = left + dx;
                      widget.drag.left = left;
                    });
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall(
      {Key? key,
      required this.onDrag,
      required this.indicatorController,
      required this.drag,
      required this.location})
      : super(key: key);

  final Function onDrag;
  final IndicatorController indicatorController;
  final DraggableController drag;
  final String location;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;
  late IndicatorController controller;
  late bool showed;
  late DraggableController position;
  late SystemMouseCursor _cursor;

  @override
  void initState() {
    _determineCursor();
    controller = widget.indicatorController;
    position = widget.drag;
    showed = controller.isShowed;
    controller.addListener(showBox);
    super.initState();
  }

  void showBox() {
    setState(() {
      showed = controller.isShowed;
    });
  }

  void _determineCursor() {
    if (widget.location == 'top left') {
      _cursor = SystemMouseCursors.resizeUpLeft;
    } else if (widget.location == 'top center') {
      _cursor = SystemMouseCursors.resizeUp;
    } else if (widget.location == 'top right') {
      _cursor = SystemMouseCursors.resizeUpRight;
    } else if (widget.location == 'center left') {
      _cursor = SystemMouseCursors.resizeLeft;
    } else if (widget.location == 'center right') {
      _cursor = SystemMouseCursors.resizeRight;
    } else if (widget.location == 'bottom left') {
      _cursor = SystemMouseCursors.resizeDownLeft;
    } else if (widget.location == 'bottom center') {
      _cursor = SystemMouseCursors.resizeDown;
    } else if (widget.location == 'bottom right') {
      _cursor = SystemMouseCursors.resizeDownRight;
    } else {
      _cursor = SystemMouseCursors.click;
    }
  }

  @override
  void dispose() {
    controller.removeListener(showBox);
    super.dispose();
  }

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
      position.initX = initX;
      position.initY = initY;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    position.initX = initX;
    position.initY = initY;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showed,
      child: GestureDetector(
        onPanStart: _handleDrag,
        onPanUpdate: _handleUpdate,
        child: MouseRegion(
          cursor: _cursor,
          child: Container(
            width: ballDiameter,
            height: ballDiameter,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ),
    );
  }
}
