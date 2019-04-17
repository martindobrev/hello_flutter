
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
        /*
        onPanStart: (details) {
          this.myFirstModel.onPanStart(details);
        },

        onPanUpdate: (details) {
          this.myFirstModel.onPanUpdate(details);
        },

        onPanDown: (details) {

        },
        */
        
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
            fit: BoxFit.cover,
            child: Transform.translate(
              offset: myFirstModel.offset,
              child: Transform.scale(
                scale: this.myFirstModel.scale,
                child: SizedBox(
                    width: this.myFirstModel.width,
                    height: this.myFirstModel.height,
                    child: CustomMultiChildLayout(
                      delegate: MyCustomMultiChildLayoutDelegate(this.myFirstModel),
                      children: _getChildren(),
                    )))))
            );
  }

  List<Widget> _getChildren() {
    List<Widget> children = [];
    children.add(LayoutId(id: 'image', child: Image.file(this.myFirstModel.file)));
    for (var i = 0; i < this.myFirstModel.textBlocks.length; i++) {
      final TextBlock tb = this.myFirstModel.textBlocks[i];
      children.add(LayoutId(id: i + 1, child: MyCustomRectWidget(this.myFirstModel, tb)));
    }
    return children;
  }
}



class MyCustomMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  MyCustomMultiChildLayoutDelegate(this.model);

  final MyFirstModel model;

  @override
  void performLayout(ui.Size size) {
    if (hasChild('image')) {
      layoutChild('image', BoxConstraints.loose(size));
      positionChild('image', Offset.zero);
    }

    for (var i = 0; i < model.textBlocks.length; i++) {
      final TextBlock tb = model.textBlocks[i];

      layoutChild(i + 1,
          BoxConstraints.tightFor(width: tb.width, height: tb.height));
      positionChild(i + 1, Offset(tb.top, tb.left));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}