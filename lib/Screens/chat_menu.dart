import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/MyWidgets/chatlist_card.dart';

class ChatMenu extends StatefulWidget {

  @override
  State<ChatMenu> createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late UserModel myData;
  List<UserModel> userDataList = [];
  List<String> uidList = [];
  bool loaded = false;

  getChats() async {

    final uids = await firestore.collection("Users").get();
    for(var uid in uids.docs){
      print(uid["uid"]);
      try{
        final data = await firestore.collection("Users").doc(myData.uid).collection("Chats").doc(uid["uid"]).collection("Messages").get();
        String senderUid = data.docs[0]["senderUid"];
        final user = await firestore.collection("Users").doc(senderUid).get();
        userDataList.add(UserModel(name: user["name"], email: user["email"], uid: user["uid"], role: user["role"]));
        uidList.add(user["uid"]);
        //cards.add(ChatListCard(name: user["name"], email: user["email"], uid: user["uid"], role: user["role"]));
      }
      catch(e) {
        print("excet");
      }

    }
    setState(() {
      loaded = true;
    });

  }

  getMyData() async {
    if(auth.currentUser!=null){
      final data = await firestore.collection("Users").doc(auth.currentUser!.uid).get();

      setState((){
        myData = UserModel(name: data["name"], email: data["email"], uid: data["uid"], role: data["role"]);
      });
      getChats();

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded ? StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("Users").snapshots(),
        builder: (context, snapshot) {

          if(snapshot.hasData){
            var users = snapshot.data?.docs;

            List<ChatListCard> cards = [];
            for(var user in users!){
              for(var u in uidList){
                if(u == user["uid"])
                cards.add(ChatListCard(name: user["name"], email: user["email"], uid: user["uid"], role: user["role"]));

              }
            }

            if(cards.isEmpty){
              return Center(
                child: LottieBuilder.asset("Animations/empty.json",),);
            }
            else{
              return ListView(
                children: cards,
              );

            }
          }
          else{
            return Text("");
          }

        },
      ) : Center(child: LottieBuilder.asset("Animations/paw_loading.json", repeat: true, reverse: true, width: MediaQuery.of(context).size.width * 0.7, height: MediaQuery.of(context).size.height * 0.7,)),
    );
  }
}
