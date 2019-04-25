import 'package:flutter/material.dart';

class QuantityEditor extends StatefulWidget {
  final int quantity;
  QuantityEditor(this.quantity);

  _QuantityEditorState _state;

  @override
  State<StatefulWidget> createState() {
    _state = _QuantityEditorState(this.quantity);
    return _state;
  }

  int getValue() {
    return _state.value > 0 ? _state.value: 1;
  }
}

class _QuantityEditorState extends State<QuantityEditor> {
  final int initialQuantity;
  int value;
  List<String> characters = [];

  _QuantityEditorState(this.initialQuantity) {
    this.value = this.initialQuantity;
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
              child: Text(this.value.toString(), style: TextStyle(fontSize: 20),))
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

  

  void preparePresentation() {
    if (this.value == null) {
      this.value = 0;
    }
    
    var representation = value.toString();
    characters.clear();
    for (int i = 0; i < representation.length; i++) {
      characters.add(representation[i]);
    }
  }

  void calculateValueFromChars() {
    if (this.characters.isEmpty) {
      this.characters.add('0');
    }

    this.value = int.parse('${this.characters.join()}');
    preparePresentation();
  }
}
