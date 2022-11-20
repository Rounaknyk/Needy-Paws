import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needy_paw/Classes/get_time.dart';
import 'package:needy_paw/MyWidgets/community_chat_bubble.dart';

import '../constants.dart';

class CommunityChatScreen extends StatefulWidget {

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {

  TextEditingController controller = TextEditingController();
  String msg = "";
  late String role, senderUid, name;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController _scrollController = new ScrollController();

  sendMsg(){
    firestore.collection("Community").doc(DateTime.now().millisecondsSinceEpoch.toString().toString()).set(
        {
          "text" : msg,
          "time" : GetTime().getTime(DateTime.now().millisecondsSinceEpoch, context),
          "senderUid" : senderUid,
          "role" : role,
          "name" : name
        }
    );

    controller.clear();
    // _needsScroll = true;
  }

  getMyData() async {
    if(auth.currentUser!=null){

      senderUid = auth.currentUser!.uid;

      final data = await firestore.collection("Users").doc(senderUid).get();
      role = data["role"];
      name = data["name"];

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyData();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.animateTo(
    //         _scrollController.position.maxScrollExtent,
    //         duration: Duration(milliseconds: 200),
    //         curve: Curves.easeInOut
    //     );
    //   }
    // });
  }
  //
  // bool _needsScroll = false;
  //
  // _scrollToEnd() async {
  //   _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 200),
  //       curve: Curves.easeInOut
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //
    // if (_needsScroll) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     return _scrollToEnd();
    //   });
    //   _needsScroll = false;
    //
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Animal Lovers Community"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("Community").snapshots(),
              builder: (context, snapshot) {

                if(snapshot.hasData){
                  var msgs = snapshot.data?.docs;

                  List<CommunityChatBubble> texts = [];
                  for(var msg in msgs!){
                    // cm = ChatModel(msg["text"], msg["time"], msg["isMe"], msg["senderUid"], msg["myUid"]);
                    texts.add(CommunityChatBubble(text: msg["text"], senderUid: msg["senderUid"], time: msg["time"], myUid: senderUid, role: msg["role"], name: msg["name"],));
                    print("$senderUid \n ${msg["senderUid"]}");
                  }

                  return Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListView(
                        controller: _scrollController,
                        children: texts,
                      ),
                    ),
                  );

                }
                else{
                  return Text("No data");
                }

              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 8, left: 8, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5,),
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
                        sendMsg();
                      },
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

