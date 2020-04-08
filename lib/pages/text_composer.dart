import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  
  TextComposer(this._sendMessage);

  final Function ({String text, File imgFile}) _sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _isComposing = false;
  final TextEditingController _controller = TextEditingController();

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.photo_camera),
          onPressed: () async {
            final File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
            if(imgFile == null) return;
            //print(imgFile);
            widget._sendMessage(imgFile: imgFile); 
          },
        ),
        Expanded(
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.black26, width: 1.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enviar uma Mensagem", 
                border: InputBorder.none,
                filled: true, 
              ),
              controller: _controller,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                if (_isComposing) {
                  widget._sendMessage(text: text);
                  _reset();
                }
              },
            ),
          )
        ),
        IconButton(
          icon: Icon(Icons.send), 
          onPressed: _isComposing ? () {
            widget._sendMessage(text: _controller.text);
            _reset();
          } : null,
        ),
      ],
    );
  }
}