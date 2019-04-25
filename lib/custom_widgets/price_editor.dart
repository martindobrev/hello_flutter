import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class PriceEditor extends StatefulWidget {
  final double price;
  PriceEditor(this.price);

  PriceEditorState _state;

  @override
  State<StatefulWidget> createState() {
    _state = PriceEditorState(this.price);
    return _state;
  }

  Decimal getValue() {
    return _state.value;
  }
}

class PriceEditorState extends State<PriceEditor> {
  final double initialPrice;
  Decimal value;
  String representation;
  List<String> characters = [];

  PriceEditorState(this.initialPrice) {
    this.value = Decimal.tryParse(initialPrice.toString());
    preparePresentation();
  }

  @override
  Widget build(BuildContext context) {

    return Column( 
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(this.representation, style: TextStyle(fontSize: 20),))
          ] 
        ),
        

        Padding(
          padding: EdgeInsets.only(top: 20),
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            
            SizedBox(
              width: 50,
                child: FlatButton(
                child: Text('1'),
                onPressed: () {pressed('1');},
              ),
            ),
            SizedBox(
              width: 50,
                child: FlatButton(
                child: Text('2'),
                onPressed: () {pressed('2');},
              ),
            ),
            SizedBox(
              width: 50,
                        child: FlatButton(
                child: Text('3'),
                onPressed: () {pressed('3');},
              ),
            )
          ],),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          SizedBox(
            width: 50,
            child: FlatButton(
              child: Text('4'),
              onPressed: () {pressed('4');},
            ),
          ),
          SizedBox(
            width: 50,
              child: FlatButton(
              child: Text('5'),
              onPressed: () {pressed('5');},
            ),
          ),
          SizedBox(
            width: 50,
              child: FlatButton(
              child: Text('6'),
              onPressed: () {pressed('6');},
            ),
          )
        ],),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          SizedBox(
            width: 50,
            child: FlatButton(
              child: Text('7'),
              onPressed: () {pressed('7');},
            ),
          ),
          SizedBox(
            width: 50,
            child: FlatButton(
              child: Text('8'),
              onPressed: () {pressed('8');},
            ),
          ),
          SizedBox(
            width: 50,
              child: FlatButton(
              child: Text('9'),
              onPressed: () {pressed('9');},
            ),
          )
        ],)
        ,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          SizedBox(
            width: 50,
              child: FlatButton(
              child: Text('C', style: TextStyle(color: Colors.deepOrange)),
              onPressed: () {pressed('CLEAR');},
            ),
          ),
          SizedBox(
            width: 50,
            child: FlatButton(
              child: Text('0'),
              onPressed: () {pressed('0');},
            ),
          ),
          SizedBox(
            width: 50,
            child: FlatButton(
              child: Text('<-'),
              onPressed: () {pressed('DELETE');},
            ),
          )
        ],)

      ],);
    
    
  }

  void pressed(String button) {

    switch (button) {
      case 'CLEAR':
        this.characters.clear();
        break;

      case 'DELETE': 
        this.characters.removeLast();
        break;
      default:
        this.characters.add(button);
        break;
    }
    this.calculateValueFromChars();
    setState(() {
      
    });
  }

  void resetValue() {
    this.value = Decimal.fromInt(0);
  }

  void preparePresentation() {
    if (this.value == null) {
      this.value = Decimal.fromInt(1);
    }
    
    this.representation = value.toStringAsFixed(2);
    characters.clear();
    for (int i = 0; i < this.representation.length; i++) {
      var char = this.representation[i];
      if (int.tryParse(char) != null) {
        characters.add(char);
      }
    }
  }

  void calculateValueFromChars() {
    List<String> values = [];
    List<String> fractions = [];

    if (this.characters.length < 3) {
      for (var i = 0; i < 3 - this.characters.length; i++) {
        values.add('0');
      }
    }

    values.addAll(this.characters);

    fractions.insert(0, values.removeLast());
    fractions.insert(0, values.removeLast());
    
    this.value = Decimal.parse('${values.join()}.${fractions.join()}');
    preparePresentation();
    
  }
}
