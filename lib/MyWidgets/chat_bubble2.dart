import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatBubble2 extends StatelessWidget {

  ChatBubble2({required this.text, required this.isMe, this.userName = 'u'});
  String text, userName;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Visibility(visible: !isMe, child: CircleAvatar(child: LottieBuilder.asset('Animations/robot.json'), backgroundColor: Colors.transparent,)),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(color: isMe ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(8),),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 16,),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
