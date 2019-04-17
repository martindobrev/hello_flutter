import 'dart:collection';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class MyFirstModel extends Model {
  final List<TextBlock> _textBlocks = [];

  File _file;
  ui.Image _image;
  double _width;
  double _height;
  double scale = 1.0;
  double _tempScale = 1.0;

  TextBlock _editedTextBlock;

  ui.Offset _translate = ui.Offset.zero;

  ui.Offset _startPosition;

  UnmodifiableListView<TextBlock> get textBlocks =>
      UnmodifiableListView(_textBlocks);
  UnmodifiableListView<TextBlock> get selectedTextBlocks => UnmodifiableListView(textBlocks.where((tblock) => tblock.selected));

  TextBlock get editedTextBlock => _editedTextBlock;

  double get width => _width;
  double get height => _height;

  File get file => _file;
  ui.Image get image => _image;

  ui.Offset get offset => _translate;

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
      _width = _image.width.toDouble();
      _height = _image.height.toDouble();
    }

    _generateTextBlocks(_width, _height);

    notifyListeners();
  }

  onScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    if (scaleUpdateDetails == null) {
      return;
    }

    print('SCALE UPDATE IS: ${scaleUpdateDetails.scale}');

    scale = _tempScale * scaleUpdateDetails.scale;

    notifyListeners();
  }

  void onScaleStart(ScaleStartDetails details) {
    _tempScale = scale;
    //print('ON SCALE START DETAILS: ${details.focalPoint.}');
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (_tempScale > 10.0) {
      scale = 10.0;
    }

    if (_tempScale < 0.1) {
      scale = 0.1;
    }
  }

  void onPanStart(DragStartDetails details) {
    //print('ON PAN START: $details');

    this._startPosition = details.globalPosition;
  }

  void onPanUpdate(DragUpdateDetails details) {
    //print('ON PAN UPDATE:');
    //print('----> GLOBAL POSITION: ${details.globalPosition}');
    //print('----> DELTA          : ${details.delta}');
    this._translate = Offset(
        this.offset.dx + details.delta.dx, this.offset.dy + details.delta.dy);
    //print('----> TRANSLATE : ${this._translate}');
    notifyListeners();
  }

  void _generateTextBlocks(double width, double height) {

    List<TextBlock> textBlocks = [];
    if (width > 0 && height > 0) {

      final double textBlockWidth = width / 10;
      final double textBlockHeight = height / 10;

      for (var i = 0; i < 5; i++) {
        textBlocks.add(TextBlock(i, false, i * textBlockWidth, i * textBlockHeight, textBlockWidth, textBlockHeight, 'Text Block ${i + 1}  - ${i + 1}'));
      }
    }

    this._textBlocks.clear();
    this._textBlocks.addAll(textBlocks);
  }

  void selectTextBlock(TextBlock textBlock) {
    if (textBlock == null) {
      return;
    }

    if (this._textBlocks.length > textBlock.index) {
      this._textBlocks[textBlock.index]  = TextBlock.select(this._textBlocks[textBlock.index]);
    }

    notifyListeners();

  }
}

class TextBlock {
  TextBlock(this.index, this.selected, this.left, this.top, this.width, this.height, this.text);
  final int index;
  final double width;
  final double height;
  final double top;
  final double left;
  final bool selected;
  String text;

  static TextBlock select(TextBlock block) {
    return TextBlock(block.index, true, block.left, block.top, block.width, block.height, block.text);
  }
}
