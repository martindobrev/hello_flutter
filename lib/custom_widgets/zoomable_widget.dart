
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hello_flutter/custom_widgets/custom_box_widget.dart';
import 'package:hello_flutter/model/my_first_model.dart';

class MyZoomableImage extends StatelessWidget {
  MyZoomableImage(this.myFirstModel);

  final MyFirstModel myFirstModel;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        
        onScaleStart: (details) {
          this.myFirstModel.onScaleStart(details);
        },
        onScaleEnd: (details) {
          print('ON SCALE END: $details');
        },
        onScaleUpdate: (details) {
          //print('SCALE FROM UPDATE IS: ${details.scale}');
          //print('   -> SCALE HORIZONTAL: ${details.horizontalScale}');
          //print('   -> SCALE VERTICAL:  ${details.verticalScale}');
          
          //if (details.horizontalScale != 1.0 || details.verticalScale != 1.0) {
          //this.myFirstModel.
          //  this.scale = newScale;
          //});
          //}

          this.myFirstModel.onScaleUpdate(details);
          
        },

        child: FittedBox(
            fit: BoxFit.contain,
            child: Transform.translate(
              offset: myFirstModel.offset,
              child: Transform.scale(
                scale: this.myFirstModel.scale,
                child: SizedBox(
                    width: this.myFirstModel.width,
                    height: this.myFirstModel.height,
                    child: CustomMultiChildLayout(
                      //delegate: MyCustomMultiChildLayoutDelegate(this.myFirstModel, _off),
                      children: _getChildren(),
                    )))))
            );
  }

  List<Widget> _getChildren() {
    List<Widget> children = [];
    children.add(LayoutId(id: 'image', child: Image.file(this.myFirstModel.file)));
    for (var i = 0; i < this.myFirstModel.textBlocks.length; i++) {
      final TextAreaInImage tb = this.myFirstModel.textBlocks[i];
      children.add(LayoutId(id: i + 1, child: MyCustomRectWidget(this.myFirstModel, tb)));
    }
    return children;
  }
}



class MyCustomMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  MyCustomMultiChildLayoutDelegate(this.model, this.scale, this.offset);

  final MyFirstModel model;
  final double scale;
  final Offset offset;

  @override
  void performLayout(ui.Size size) {

    final REAL_SCALE = size.width / model.width;



    if (hasChild('image')) {
      layoutChild('image', BoxConstraints.loose(size));
      positionChild('image', Offset.zero);
    }

    for (var i = 0; i < model.textBlocks.length; i++) {
      final TextAreaInImage tb = model.textBlocks[i];


      //final newLeft = tb.t


      layoutChild(i + 1,
          BoxConstraints.tightFor(width: tb.textLine.boundingBox.width.toDouble(), height: tb.textLine.boundingBox.height.toDouble()));
      positionChild(i + 1, Offset(tb.textLine.boundingBox.left.toDouble(), tb.textLine.boundingBox.top.toDouble()));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
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
                    child: SizedBox(
                      width: model.width, height: model.height,
                                        child: CustomMultiChildLayout(
                            delegate: MyCustomMultiChildLayoutDelegate(this.model, _scale, _offset),
                            children: children
            ,
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
    
    //print('GEtting children to render... -> length: ${children.length}');
    return children;
  }
}