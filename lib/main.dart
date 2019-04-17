import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hello_flutter/custom_widgets/my_selectable_list.dart';
import 'package:hello_flutter/custom_widgets/zoomable_widget.dart';
import 'package:hello_flutter/model/my_first_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var model = MyFirstModel();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ScopedModel<MyFirstModel>(
        model: model,
        child: 
        MyNewHomePage(model),
      )
    );
  }
}


class MyNewHomePage extends StatelessWidget {

  MyNewHomePage(this.model);
  final MyFirstModel model;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Hellloooo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ScopedModelDescendant<MyFirstModel>(
              builder: (context, child, model)  {
                if (model.image == null) {
                  return Text('Please select image');
                } else {
                  //return Image.file(model.file);
                  return MyZoomableImage(model);
                }
              }
            ),
          ),
          Expanded(
            flex: 1,
            child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.blueAccent),
                          child: ScopedModelDescendant<MyFirstModel>(
                 builder: (context, child, model) {
                   return MySelectableList(model);
                 }),
            ),
          )
        ]
      ),
      floatingActionButton: ScopedModelDescendant<MyFirstModel>(
        builder: (context, child, model) {
          return FloatingActionButton(
            onPressed: () {
              model.getImage();
            },
            child: Icon(Icons.image)
          );
        })
    );
  }

}


