import 'package:fluent_ui/fluent_ui.dart';

const _cornerDiameter = 22.0;
const _floatingActionDiameter = 18.0;
const _floatingActionPadding = 24.0;

class DraggableDimension {
  DraggableDimension(
      {required this.angle,
      required this.position,
      required this.size,
      required this.constraints});

  final double angle;
  final Offset position;
  final Size size, constraints;
}

class ResizableEdges extends StatefulWidget {
  ResizableEdges({
    Key? key,
    required this.child,
    required this.size,
    BoxConstraints? constraints,
    this.onUpdate,
    this.onLayerTapped,
    this.onEdit,
    this.onDelete,
    this.canTransform = false,
  }) : constraints = constraints ?? BoxConstraints.loose(Size.infinite);

  // Widget that can be reziable
  final Widget child;

  // Handles Resizing of the widget
  final ValueSetter<DraggableDimension>? onUpdate;

  // Handles the functionality of the edges
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLayerTapped;

  //Whether the widget can be resized. Defaule value: false
  final bool canTransform;

  // Original Size of the child widget
  final Size size;

  // The Child's Constraints.
  // Defaults to [BoxConstraints.loose(Size.infinite)].
  final BoxConstraints constraints;

  @override
  _ResizableEdgesState createState() => _ResizableEdgesState();
}

class _ResizableEdgesState extends State<ResizableEdges> {
  late Size size;
  late BoxConstraints constraints;
  late double angle;
  late double angleDelta;
  late double baseAngle;

  Offset position = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.size.width / widget.size.height;
    return LayoutBuilder(
      builder: ((context, constraints) {
        position = position == Offset.zero
            ? Offset(constraints.maxWidth / 2 - (size.width / 2),
                constraints.maxHeight / 2 - (size.height / 2))
            : position;
        final normalizedWidth = size.width;
        final normalizedHeight = normalizedWidth / aspectRatio;
        final newSize = Size(normalizedWidth, normalizedHeight);

        if (widget.constraints.isSatisfiedBy(newSize)) size = newSize;
        final normalizedLeft = position.dx;
        final normalizedTop = position.dy;

        void onUpdate() {
          final normalizedPosition = Offset(
            normalizedLeft +
                (_floatingActionPadding / 2) +
                (_cornerDiameter / 2),
            normalizedTop +
                (_floatingActionPadding / 2) +
                (_cornerDiameter / 2),
          );
          widget.onUpdate?.call(
            DraggableDimension(
              position: normalizedPosition,
              size: size,
              constraints: Size(constraints.maxWidth, constraints.maxHeight),
              angle: angle,
            ),
          );
        }

        onUpdate();
        return Container();
      }),
    );
  }
}
