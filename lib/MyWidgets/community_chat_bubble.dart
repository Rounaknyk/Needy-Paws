import 'package:flutter/material.dart';

class CommunityChatBubble extends StatefulWidget {

  CommunityChatBubble({required this.text, required this.senderUid, required this.time, required this.myUid, required this.role, required this.name});
  late String text, name;
  late String time, senderUid, myUid, role;

  @override
  State<CommunityChatBubble> createState() => _CommunityChatBubble();
}

class _CommunityChatBubble extends State<CommunityChatBubble> {
  late bool isMe;
  late String role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    role = (widget.role == "user") ? "" : "(${widget.role.toUpperCase()})";

    isMe = (widget.myUid == widget.senderUid) ? true : false;

    // BubbleSpecialThree()
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.only(
            topRight: isMe ? Radius.circular(0) : Radius.circular(25),
            topLeft: isMe ? Radius.circular(25) : Radius.circular(0),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12, right: isMe ? 10 : 15, left: isMe ? 15 : 10),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text("${widget.name} $role", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isMe ? Colors.white : Colors.black),),
                  Text("at ${widget.time}", style: TextStyle(fontSize: 10, color: isMe ? Colors.white : Colors.black),),
                  SizedBox(height: 8,),
                  Text(widget.text, style: TextStyle(fontSize: 14, color: isMe ? Colors.white : Colors.black, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: isMe ? Colors.lightBlue : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: isMe ? Radius.circular(0) : Radius.circular(25),
                topLeft: isMe ? Radius.circular(25) : Radius.circular(0),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
