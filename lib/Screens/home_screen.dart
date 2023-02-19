import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Classes/get_post_time.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/Models/post_model.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/constants.dart';
import 'package:needy_paw/my_routes.dart';
import 'package:needy_paw/MyWidgets/reusable_card.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();

  HomeScreen({required this.myData});
  late UserModel myData;
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  late PostModel pm;

  List<ReusableCard> postList = [];

  getData() async {
    final user = auth.currentUser;
    if (user != null) {
      uid = user.uid.toString();
      final data = await firestore.collection("Users").doc(user.uid).get();
      setState(() {
        widget.myData = UserModel(
            name: data["name"],
            email: data["email"],
            uid: uid,
            role: data["role"]);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.myData == null) getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(automaticallyImplyLeading: false, centerTitle: false, title: Text("Hey ${pm.name} !", style: TextStyle(color: Colors.black, fontSize: 30),), backgroundColor: kBackgroundColor, elevation: 0,),
      floatingActionButton: (widget.myData != null)
          ? FloatingActionButton(
              onPressed: () {
                if (widget.myData.role == "vet")
                  Navigator.pushNamed(context, MyRoutes.add_clinic);
                else
                  Navigator.pushNamed(context, MyRoutes.add_animal);
              },
              child: Icon(Icons.pets),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection("Posts").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var postData = snapshot.data?.docs;
              String token = "";
              List<ReusableCard> posts = [];
              for (var post in postData!) {
                // cm = ChatModel(msg["text"], msg["time"], msg["isMe"], msg["senderUid"], msg["myUid"]);
                if (auth.currentUser!.uid != post["uid"]) {
                  posts.add(ReusableCard(
                    pm: PostModel(
                      url: post["url"],
                      des: post["des"],
                      ltlg: Ltlg(post["lat"], post["lng"]),
                      time: post["time"],
                      infection: post["infection"],
                      manual_address: post["manual_address"],
                      name: post["name"],
                      uid: post["uid"],
                      pId: post["pId"],
                      token: post["token"],),),);
                }
              }
              if (posts.isEmpty) {
                return Center(
                  child: LottieBuilder.asset(
                    "Animations/empty.json",
                  ),
                );
              } else {
                return ListView(
                  children: posts,
                );
              }
            } else {
              return Center(
                child: LottieBuilder.asset(
                  "Animations/paw_loading.json",
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}