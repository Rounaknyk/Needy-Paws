import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  ChatBubble({required this.text, required this.isMe, required this.time});
  late bool isMe;
  late String text;
  late String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.only(
            topRight: isMe ? Radius.circular(0) : Radius.circular(10),
            topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: isMe ? 10 : 15, left: isMe ? 15 : 10),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(time, style: TextStyle(fontSize: 10),),
                  SizedBox(height: 8,),
                  Text(text, style: TextStyle(fontSize: 15),),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: isMe ? Colors.greenAccent : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: isMe ? Radius.circular(0) : Radius.circular(10),
                topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
