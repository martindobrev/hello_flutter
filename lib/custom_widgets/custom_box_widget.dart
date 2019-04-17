import 'package:flutter/material.dart';
import 'package:hello_flutter/model/my_first_model.dart';

class MyCustomRectWidget extends StatelessWidget {
  MyCustomRectWidget(this.model, this.textBlock);
  final TextBlock textBlock;
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
    if (this.textBlock.selected) {
      return Colors.deepOrange;
    }

    return Colors.grey;
  }
}