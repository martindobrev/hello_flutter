import 'package:flutter/material.dart';
import 'package:hello_flutter/model/my_first_model.dart';

class MyCustomRectWidget extends StatelessWidget {
  MyCustomRectWidget(this.model, this.textBlock);
  final TextAreaInImage textBlock;
  final MyFirstModel model;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {

          this.model.selectTextBlock(textBlock);
          print('Text: ${textBlock.text} was selected!');
        },
        child: Container(
            decoration: BoxDecoration(color: _getColor())));
  }
            
  _getColor() {
    var opacity = 0.4;
    var color = Colors.grey;
    if (this.textBlock.selected) {
      color = Colors.deepOrange;
    }
    return Color.fromRGBO(color.red, color.green, color.blue, opacity);
  }
}