import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/my_routes.dart';

import '../Models/Ltlg.dart';
import '../Models/post_model.dart';
import '../MyWidgets/reusable_card.dart';

class AccountScreen extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  AccountScreen({required this.myData});
  UserModel myData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.logout),
          onPressed: () {
            auth.signOut();
            Navigator.pushNamed(context, MyRoutes.login);
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(right: 10, left: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey ${myData.name}",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "below are your posts",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection("Posts").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var postData = snapshot.data?.docs;

                        List<ReusableCard> posts = [];
                        for (var post in postData!) {
                          // cm = ChatModel(msg["text"], msg["time"], msg["isMe"], msg["senderUid"], msg["myUid"]);
                          if (auth.currentUser!.uid == post["uid"])
                            posts.add(ReusableCard(
                                pm: PostModel(
                                    url: post["url"],
                                    des: post["des"],
                                    ltlg: Ltlg(post["lat"], post["lng"]),
                                    time: post["time"],
                                    infection: post["infection"],
                                    manual_address: post["manual_address"],
                                    name: post["name"],
                                    uid: post["uid"])));
                          // print("$senderUid \n ${msg["senderUid"]}");
                        }

                        return ListView(
                          children: posts,
                        );
                      } else {
                        return Text("No data");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

/*
 CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlexibleSpaceBar(
                  title: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Hey Rounak \n below are your posts",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
 */
