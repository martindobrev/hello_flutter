

import 'package:flutter/material.dart';
import 'package:hello_flutter/model/my_first_model.dart';

class MySelectableList extends StatelessWidget {

  MySelectableList(this.model);

  final MyFirstModel model;

  @override
  Widget build(BuildContext context) {
    List<Hero> widgets = [];
    
    if (model.selectedTextBlocks != null) {
      widgets = this.model.selectedTextBlocks
      .map((tBlock) => Hero(tag: tBlock.index, child: MyTextBlockListItem(tBlock))).toList();
    }
    return ListView(
      children: widgets
    );
  }

}

class MyTextBlockListItem extends StatelessWidget {

  MyTextBlockListItem(this.textBlock);

  final TextBlock textBlock;

  @override
  Widget build(BuildContext context) {
    print('TEXT BLOCK IS: ${this.textBlock}');

    
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
        }));
      },
      child: Text(this.textBlock != null ? this.textBlock.text: 'UNDEFINED'));
  }
}

class DetailScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text('GO BACK'));
  }
}