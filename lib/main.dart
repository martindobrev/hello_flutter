import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hello_flutter/custom_widgets/my_bottom_menu.dart';
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
          child: HomePage(model),
        ));
  }
}

class HomePage extends StatelessWidget {
  final MyFirstModel model;
  HomePage(this.model);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('CHANGE_TITLE')),
        body: Stack(
          children: <Widget>[
            ScopedModelDescendant<MyFirstModel>(
                builder: (context, child, model) {
              if (model.image == null) {
                return Center(
                  child: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        model.getImage();
                      }),
                );
              } else {
                return Align(
                    alignment: Alignment.center, child: MyZoomableImage(model));
              }
            }),
            Align(
                alignment: Alignment.bottomCenter,
                child: MyBottomMenu(model))
          ],
        ));
  }
  
}