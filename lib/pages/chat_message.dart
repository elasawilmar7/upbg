import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {

  ChatMessage(this.mine, this.documents);

  final mine;
  final documents;

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: widget.mine? Colors.blue[100]: Colors.grey[300],
      padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.symmetric(vertical: 3.0),
      width: MediaQuery.of(context).size.width * 0.10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: widget.mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.documents['from'],
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 5,),
            widget.documents['imgFile'] != null ? 
            Image.network(widget.documents['imgFile']):
            Text(
              widget.documents['text'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}