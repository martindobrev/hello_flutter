import 'dart:collection';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MyFirstModel extends Model {
  final List<TextAreaInImage> _textAreas = [];

  File _file;
  ui.Image _image;
  double _width;
  double _height;
  double scale = 1.0;
  double _tempScale = 1.0;

  TextAreaInImage _editedTextBlock;

  ui.Offset _translate = ui.Offset.zero;

  UnmodifiableListView<TextAreaInImage> get textBlocks =>
      UnmodifiableListView(_textAreas);
  UnmodifiableListView<TextAreaInImage> get selectedTextBlocks =>
      UnmodifiableListView(textBlocks.where((tblock) => tblock.selected));

  TextAreaInImage get editedTextBlock => _editedTextBlock;

  double get width => _width;
  double get height => _height;

  File get file => _file;
  ui.Image get image => _image;

  ui.Offset get offset => _translate;

  ui.Offset _dragStartPosition;

  Future<ui.Image> _loadImage(File file) async {
    if (file == null) {
      return null;
    }
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }

  void getImage() async {
    _file = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = await _loadImage(file);

    _width = 0;
    _height = 0;

    if (_image != null) {

      final visionImage = FirebaseVisionImage.fromFile(_file);
      final textDetector = FirebaseVision.instance.textRecognizer();
      final visionText = await textDetector.processImage(visionImage);

      

      _width = _image.width.toDouble();
      _height = _image.height.toDouble();
      scale = 1.0;
      _translate = Offset.zero;
      final List<TextLine> lines = _linesFromBlocks(visionText.blocks);

      _textAreas.clear();
      _textAreas.addAll(_createTextAreas(lines));
    }

    notifyListeners();
  }

  List<TextAreaInImage> _createTextAreas(List<TextLine> lines) {
    List<TextAreaInImage> areas = [];
    for (var i = 0; i < lines.length; i++) {
      final TextLine line = lines[i];
      areas.add(TextAreaInImage(i, false, line, line.text, extractPriceFromText(line.text).toDouble(), 1));
    }
    return areas;
  }

  Decimal extractPriceFromText(String text) {
    String rs = r'(\d+).(\d+)';
    RegExp regExp = new RegExp(rs);
  
    var matches = regExp.allMatches(text);

    if (matches.isNotEmpty) {
      final String match = matches.last.group(0).toString();
      final Decimal value = Decimal.tryParse(match);
      if (value != null) {
        return value;
      }
    }

    return Decimal.parse('1.00');
    // matches.forEach((m) => print('MATCH: ${m.group(0).toString()}'));
  }

  List<TextLine> _linesFromBlocks(List<TextBlock> blocks) {
    final List<TextLine> lines = new List();
    blocks.map((block) => block.lines).forEach((lineList) => {lines.addAll(lineList)});
    return lines;
  }

  onScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    if (scaleUpdateDetails == null) {
      return;
    }

    //print('SCALE UPDATE FOCAL POINT IS: ${scaleUpdateDetails.focalPoint}');
    //print('SCALE UPDATE IS: ${scaleUpdateDetails.scale}');

    scale = _tempScale * scaleUpdateDetails.scale;

    if (scaleUpdateDetails.scale == 1.0) {
      var dx = _dragStartPosition.dx - scaleUpdateDetails.focalPoint.dx;
      var dy = _dragStartPosition.dy - scaleUpdateDetails.focalPoint.dy;
      //print('SCALE IS 1.0 - TRANSLATING... by: $dx, $dy');
      _translate = Offset(_translate.dx - dx * 0.3, _translate.dy - dy * 0.3);
    }

    notifyListeners();
  }

  void onScaleStart(ScaleStartDetails details) {
    _tempScale = scale;

    this._dragStartPosition = details.focalPoint;
    //print('ON SCALE START DETAILS: ${details.focalPoint.}');
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (_tempScale > 10.0) {
      scale = 10.0;
    }

    if (_tempScale < 0.3) {
      scale = 0.3;
    }
  }

  

  void selectTextBlock(TextAreaInImage textBlock) {
    if (textBlock == null) {
      return;
    }

    if (this._textAreas.length > textBlock.index) {
      this._editedTextBlock = TextAreaInImage.select(this._textAreas[textBlock.index]);
      this._textAreas[textBlock.index] = this._editedTextBlock;
          
      
    }

    notifyListeners();
  }

  void deselectTextBlock(TextAreaInImage textBlock) {
    if (textBlock == null) {
      return;
    }

    if (this._textAreas.length > textBlock.index) {
      this._textAreas[textBlock.index] =
          TextAreaInImage.deselect(this._textAreas[textBlock.index]);
    }

    notifyListeners();
  }

  void changeTextBlock(int index, String label, int quantity, Decimal price) {
    this._textAreas[index] =
          TextAreaInImage.changeProperties(label, quantity, price.toDouble(), this._textAreas[index]);
    if (_editedTextBlock != null && _editedTextBlock.index == index) {
      this._editedTextBlock = this._textAreas[index];
    }
    notifyListeners();
  }

  bool menuExpanded = false;

  String getTotalPrice() {
    if (this.selectedTextBlocks.isEmpty) {
      return '0.00';
    }
    return selectedTextBlocks.map((el) => Decimal.tryParse((el.price * el.quantity).toString())).reduce((sum, el) => sum + el).toStringAsFixed(2);
  }
}

class TextAreaInImage {
  TextAreaInImage(this.index, this.selected, this.textLine, this.text, this.price, this.quantity);
  final int index;
  final bool selected;
  final TextLine textLine;
  String text;

  final double price;
  final int quantity;

  static TextAreaInImage select(TextAreaInImage area) {
    return TextAreaInImage(area.index, true, area.textLine, area.text, area.price, area.quantity);
  }

  static TextAreaInImage deselect(TextAreaInImage area) {
    return TextAreaInImage(area.index, false, area.textLine, area.text, area.price, area.quantity);
  }

  static TextAreaInImage withQuantity(int quantity, TextAreaInImage area) {
    return TextAreaInImage(area.index, false, area.textLine, area.text, area.price, area.quantity);
  }

  static TextAreaInImage changeProperties(String text, int quantity, double price, TextAreaInImage area) {
    return TextAreaInImage(area.index, area.selected, area.textLine, text, price, quantity);
  }
}