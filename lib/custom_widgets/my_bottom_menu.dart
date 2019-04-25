import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/custom_widgets/my_selectable_list.dart';
import 'package:hello_flutter/custom_widgets/price_editor.dart';
import 'package:hello_flutter/custom_widgets/quantity_editor.dart';
import 'package:hello_flutter/model/my_first_model.dart';
import 'package:scoped_model/scoped_model.dart';





class MyBottomMenu extends StatefulWidget {
  MyBottomMenu(this.model);

  final MyFirstModel model;
  

  @override
  State<StatefulWidget> createState() {
    return _MyBottomMenuState(model);
  }
}

class _MyBottomMenuState extends State<MyBottomMenu> with SingleTickerProviderStateMixin  {

  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    // #docregion addListener
    _animation = Tween<double>(begin: 100, end: 300).animate(_controller)
      ..addStatusListener((statusListener) {
        this.model.menuExpanded = (statusListener == AnimationStatus.completed);
        //print('MENU EXPANDED IS: $_menuExpanded');
        setState(() {});
      })
      ..addListener(() {
        // #enddocregion addListener
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
        // #docregion addListener
      });
  }

  _MyBottomMenuState(this.model);
  final MyFirstModel model;

  Widget build(BuildContext context) {
    var children = [
            Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.yellow,
                  child: Ink(
                    //color: Colors.blue,
                    decoration: ShapeDecoration(
                        color: Colors.white, shape: RoundedRectangleBorder()),
                    child: IconButton(
                      icon: getIcon(),
                      onPressed: () {
                        //print('TOGGLE THE MENU SOMEHOW FROM HERE!');
                        toggleMenu();
                      },
                    ),
                  ),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: ScopedModelDescendant<MyFirstModel>(
                      builder: (context, child, model) {
                        return Text('TOTAL: ${this.model.getTotalPrice()}',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold));
                      },
                    ))),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ScopedModelDescendant<MyFirstModel>(
                            builder: (context, child, model) {
                          if (model.editedTextBlock != null) {
                            return FlatButton(
                              onPressed: () {_showQuantityDialog(model, context);},
                                child: Text('QTY: ${model.editedTextBlock.quantity}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)));
                          } else {
                            return Text('');
                          }
                        }),
    
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ScopedModelDescendant<MyFirstModel>(
                              builder: (context, child, model) {
                            if (model.editedTextBlock != null) {
                              return FlatButton(
                                child: Text('PRICE: ${model.editedTextBlock.price}',
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 20)),
                                onPressed: () {
                                  _showPriceDialog(model, context);
                                },
                              );
                            } else {
                              return Text('');
                            }
                          }),
                        )
                        // IconButton(icon: Icon(Icons.edit, color: Colors.white))
                      ],
                    )))
          ];

        if (this.model.menuExpanded) {
          children.add(Align(alignment: Alignment.bottomCenter, child: Padding(
            padding: EdgeInsets.only(left: 30, top: 30),
            child: ScopedModelDescendant<MyFirstModel>(
                              builder: (context, child, model) {
                                return MySelectableList(model);}))));
        }

        return Container(
              height: _animation.value,
              color: Colors.blueAccent,
              child: Stack(children: children),
    );
  }

  Icon getIcon() {
    if (this.model.menuExpanded) {
      return Icon(Icons.arrow_downward, color: Colors.blueAccent);
    } else {
      return Icon(Icons.arrow_upward, color: Colors.blueAccent);
    }
  }

  Future<void> _showQuantityDialog(
      MyFirstModel model, BuildContext context) async {
    var quantityEditor = QuantityEditor(model.editedTextBlock.quantity);
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Adjust Quantity'),
            children: <Widget>[
              quantityEditor,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      child: Text('cancel'),
                      onPressed: () {
                        Navigator.pop(context, 'CANCEL');
                      }),
                  RaisedButton(
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                  )
                ],
                //RaisedBu

                //onPressed: () { Navigator.pop(context, 'OK'); },
                //child: const Text('Treasury department'),
              )
            ],
          );
        })) {
      case 'OK':
        //print('NEW VALUE IS: ${quan.getValue().toStringAsFixed(2)}');
        var toBeChanged = model.editedTextBlock;
        model.changeTextBlock(toBeChanged.index, toBeChanged.text,
            quantityEditor.getValue(), Decimal.parse(toBeChanged.price.toString()));
        break;
      case 'CANCEL':
        print('CANCELLED!');
        break;
    }
  }

  Future<void> _showPriceDialog(
      MyFirstModel model, BuildContext context) async {
    var priceEditor = PriceEditor(model.editedTextBlock.price);
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Adjust Price'),
            children: <Widget>[
              priceEditor,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      child: Text('cancel'),
                      onPressed: () {
                        Navigator.pop(context, 'CANCEL');
                      }),
                  RaisedButton(
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                  )
                ],
                //RaisedBu

                //onPressed: () { Navigator.pop(context, 'OK'); },
                //child: const Text('Treasury department'),
              )
            ],
          );
        })) {
      case 'OK':
        print('NEW VALUE IS: ${priceEditor.getValue().toStringAsFixed(2)}');
        var toBeChanged = model.editedTextBlock;
        model.changeTextBlock(toBeChanged.index, toBeChanged.text,
            toBeChanged.quantity, priceEditor.getValue());
        break;
      case 'CANCEL':
        print('CANCELLED!');
        break;
    }
  }

  void toggleMenu() {
    if (this.model.menuExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
