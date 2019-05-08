
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hello_flutter/custom_widgets/custom_box_widget.dart';
import 'package:hello_flutter/model/my_first_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MyCustomMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  MyCustomMultiChildLayoutDelegate(this.model);

  final MyFirstModel model;

  @override
  void performLayout(ui.Size size) {

    final realScale = size.width / model.width;

    if (hasChild('image')) {
      layoutChild('image', BoxConstraints.loose(size));
      positionChild('image', Offset.zero);
    }

    for (var i = 0; i < model.textBlocks.length; i++) {
      final TextAreaInImage tb = model.textBlocks[i];
      final newWidth = tb.textLine.boundingBox.width.toDouble() * realScale;
      final newHeight = tb.textLine.boundingBox.height.toDouble() * realScale;
      final newLeft = tb.textLine.boundingBox.left.toDouble() * realScale;
      final newTop = tb.textLine.boundingBox.top.toDouble() * realScale;

      layoutChild(i + 1,
          BoxConstraints.tightFor(width: newWidth, height: newHeight));
      positionChild(i + 1, Offset(newLeft, newTop));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}



const double _kMinFlingVelocity = 800.0;

class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({ Key key, this.model }) : super(key: key);


  final MyFirstModel model;

  @override
  _GridPhotoViewerState createState() => _GridPhotoViewerState(this.model);
}

class _GridPhotoViewerState extends State<GridPhotoViewer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  List<Widget> children = [];

  _GridPhotoViewerState(this.model);

  final MyFirstModel model;

  @override
  void initState() {
    super.initState();
    this.children = _getChildren();
    _controller = AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    return Offset(offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity)
      return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = _controller.drive(Tween<Offset>(
      begin: _offset,
      end: _clampOffset(_offset + direction * distance)
    ));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    print('MODEL WIDTH: ${model.width}, HEIGHT: ${model.height}');
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
                  child: Container(
                    child: ScopedModel<MyFirstModel>(
                      model: model,
                                child: SizedBox(
                        width: model.width, height: model.height,
                                          child: CustomMultiChildLayout(
                              delegate: MyCustomMultiChildLayoutDelegate(this.model),
                              children: _getChildren(),
                              
          ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  List<Widget> _getChildren() {
    
    List<Widget> children = [];
    children.add(LayoutId(id: 'image', child: Image.file(this.model.file)));
    for (var i = 0; i < this.model.textBlocks.length; i++) {
      final TextAreaInImage tb = this.model.textBlocks[i];
      children.add(LayoutId(id: i + 1, child: MyCustomRectWidget(this.model, tb)));
    }
    return children;
  }
}