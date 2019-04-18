

import 'package:flutter/material.dart';
import 'package:hello_flutter/model/my_first_model.dart';
import 'package:decimal/decimal.dart';

class MySelectableList extends StatelessWidget {

  MySelectableList(this.model);

  final MyFirstModel model;

  @override
  Widget build(BuildContext context) {
    List<Hero> widgets = [];
    
    if (model.selectedTextBlocks != null) {
      widgets = this.model.selectedTextBlocks
      .map((tBlock) => Hero(tag: tBlock.index, child: MyTextBlockListItem(tBlock, model))).toList();
    }
    return ListView(
      children: widgets
    );
  }

}

class MyTextBlockListItem extends StatelessWidget {

  MyTextBlockListItem(this.textBlock, this.model);

  final TextBlock textBlock;
  final MyFirstModel model;

  @override
  Widget build(BuildContext context) {
    // print('TEXT BLOCK IS: ${this.textBlock}');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
                child:DetailScreen()
              );
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(this.textBlock != null ? this.textBlock.text: 'UNDEFINED'),
          Text(Decimal.parse(this.textBlock.price.toString()).toStringAsFixed(2)),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.white,
            onPressed: () {
              this.model.deselectTextBlock(this.textBlock);
            },
          )
        ],
      ));
  }
}

class DetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text('GO BACK', style: TextStyle(color: Colors.white)));
  }
}