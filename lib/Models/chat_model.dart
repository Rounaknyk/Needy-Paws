import 'package:flutter/material.dart';

class ChatModel{

  late String text;
  late String time;
  late bool isMe;
  late String senderUid;
  late String myUid;

  ChatModel(this.text, this.time, this.isMe, this.senderUid, this.myUid);

}