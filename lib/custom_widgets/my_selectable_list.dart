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
      widgets = this
          .model
          .selectedTextBlocks
          .map((tBlock) => Hero(
              tag: tBlock.index, child: MyTextBlockListItem(tBlock, model)))
          .toList();
    }
    return ListView(children: widgets);
  }
}

class MyTextBlockListItem extends StatelessWidget {
  MyTextBlockListItem(this.textBlock, this.model);

  final TextAreaInImage textBlock;
  final MyFirstModel model;

  @override
  Widget build(BuildContext context) {
    // print('TEXT BLOCK IS: ${this.textBlock}');

    return GestureDetector(
        onTap: () {
          this.model.selectTextBlock(this.textBlock);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(this.textBlock != null ? this.textBlock.text : 'UNDEFINED'),
            Text(
                this.textBlock != null
                    ? this.textBlock.quantity.toString()
                    : 'N/A',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text(Decimal.parse(this.textBlock.price.toStringAsFixed(2))
                .toStringAsFixed(2)),
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
  DetailScreen(this.model, this.textBlock);
  final MyFirstModel model;
  final TextAreaInImage textBlock;

  String _label;
  int _quantity;
  Decimal _price;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /*
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text('GO BACK', style: TextStyle(color: Colors.white)));
      */
    return ListView(
          children: [Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: textBlock.text,
              decoration: const InputDecoration(
                hintText: 'Cappucino',
                labelText: 'Label',
              ),
              validator: (String value) {
                return value.isEmpty ? 'Set a label' : null;
              },
              onSaved: (String value) {
                _label = value;
              }
            ),
            TextFormField(
              initialValue: textBlock.quantity.toString(),
              decoration: const InputDecoration(
                hintText: '2',
                labelText: 'Quantity',
              ),
              onSaved: (String value) {
                _quantity = int.parse(value);
              },
              validator: (String value) {
                return !(int.parse(value) is int) ? 'Value must be an integer' : null;
              },
            ),
            TextFormField(
              initialValue: textBlock.price.toStringAsFixed(2),
              decoration: const InputDecoration(
                hintText: '3.70',
                labelText: 'Price',
              ),
              validator: (String value) {
                return Decimal.parse(value) == null ? 'Value must be a decimal number' : null;
              },
              onSaved: (String value) {
                _price = Decimal.parse(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')
                ),
                RaisedButton(
                  onPressed: () {
                    _submit(context);
                  },
                  child: Text('save')
                )
              ]  
            )
          ],
        ),
      ),
          ]);
  }


  void _submit(BuildContext context) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      this.model.changeTextBlock(this.textBlock.index, _label, _quantity, _price);
      Navigator.pop(context);
    }
  }
}
