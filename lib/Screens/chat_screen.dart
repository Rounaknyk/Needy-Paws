import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:needy_paw/Classes/get_time.dart';
import 'package:needy_paw/Models/post_model.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/MyWidgets/chat_bubble.dart';
import 'package:needy_paw/constants.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.senderUid, required this.senderName});

  late String senderUid;
  late String senderName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String msg = "";
  late String myUid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  sendMsg() async{
    firestore.collection("Users").doc(myUid).collection("Chats").doc(widget.senderUid).collection("Messages").doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
      {
        "text" : msg,
        "time" : GetTime().getTime(DateTime.now().millisecondsSinceEpoch, context),
        "senderUid" : widget.senderUid,
        "myUid" : myUid,
        "isMe" : true,
      }
    );

    firestore.collection("Users").doc(widget.senderUid).collection("Chats").doc(myUid).collection("Messages").doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
        {
          "text" : msg,
          "time" : GetTime().getTime(DateTime.now().millisecondsSinceEpoch, context),
          "senderUid" : myUid,
          "myUid" : widget.senderUid,
          "isMe" : false,
        }
    );

    controller.clear();

  }

  getMyData() async{
    if(auth.currentUser != null){
      myUid = auth.currentUser!.uid;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.senderName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("Users").doc(myUid).collection("Chats").doc(widget.senderUid).collection("Messages").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.hasData){
                    var msgs = snapshot.data?.docs;

                    List<ChatBubble> texts = [];
                    for(var msg in msgs!){
                      // cm = ChatModel(msg["text"], msg["time"], msg["isMe"], msg["senderUid"], msg["myUid"]);
                      texts.add(ChatBubble(text: msg["text"], isMe: msg["isMe"], time: msg["time"]));
                    }

                    return Expanded(
                      flex: 10,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: texts.length + 1,
                        itemBuilder: (context, index){
                          if(index == texts.length){
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                            );
                          }
                          else{
                            return texts[index];
                          }
                        },
                      ),
                    );

                  }
                  else{
                    return Text("No data");
                  }

                },
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8,),
                        child: Container(
                          child: TextField(
                            controller: controller,
                            onChanged: (value){
                              setState(() {
                                msg = value;
                              });
                            },
                            decoration: kTextFieldDecoration,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (){
                        if(msg.isNotEmpty) {
                          _scrollController.animateTo(_scrollController.position
                              .maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                          sendMsg();
                        }
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: SvgPicture.asset("svgs/send.svg", height: 24, width: 24, color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
