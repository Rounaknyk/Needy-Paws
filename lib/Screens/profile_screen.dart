import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/Models/post_model.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/MyWidgets/reusable_card.dart';
import 'package:needy_paw/constants.dart';

class Profilescreen extends StatefulWidget {
  Profilescreen({required this.uid});
  late String uid;
  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late UserModel userData;

  late PostModel pm;

  List<Widget> pmList = [];

  bool loaded = false;

  String name = "", role = "", email = "";

  Future getUserData() async {
    final data = await firestore.collection("Users").doc(widget.uid).get();

    setState(() {
      name = data["name"];
      role = data["role"];
      email =  data["email"];

    });

    pmList.add(
      Text(
        "${name.toUpperCase()}'s Posts",
        style: TextStyle(fontSize: 30),
      ),
    );
    
    getPosts();

  }

  Future getPosts() async {
    final posts = await firestore.collection("Posts").get();
    for (var post in posts.docs) {
      if (post["uid"] == widget.uid) {
        pm = PostModel(
            url: post["url"],
            des: post["des"],
            ltlg: Ltlg(post["lat"], post["lng"]),
            time: post["time"],
            name: post["name"],
            uid: widget.uid,
            pId: post["pId"]);
        pmList.add(ReusableCard(pm: pm));
      }
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: loaded ? Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                      child: Align(
                        child: SvgPicture.asset(
                          "svgs/user.svg",
                          height: 100,
                          width: 100,
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$name",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$role",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3),
                    ),
                    Text(
                      "$email",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.1,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    color: kBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[900]),
                          height: 5,
                          width: 50,
                        ),
                        Expanded(
                          child: ListView(
                                  controller: scrollController,
                                  children: pmList,
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ) : Center(child: LottieBuilder.asset("Animations/paw_loading.json", height: MediaQuery.of(context).size.height * 0.5, width: MediaQuery.of(context).size.width * 0.5,)),
        ),
      ),
    );
  }
}

/*
ListView(
                            controller: scrollController,
                            children: [
                              Text(
                                "Rounak's Posts",
                                style: TextStyle(fontSize: 30),
                              ),
                              ReusableCard(
                                  pm: PostModel(
                                      url:
                                          'https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/app_icon%2Fapp_icon.png?alt=media&token=b90f368f-4147-4ab8-8c6f-2a3fe3e98661',
                                      des: '',
                                      ltlg: Ltlg(213.32, 124.3),
                                      time: '9:00 AM',
                                      name: 'Rounak',
                                      uid: 'adkyiasdhkljad',
                                      pId: 'lakdjaljdasdd')),
                              ReusableCard(
                                  pm: PostModel(
                                      url:
                                          'https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/app_icon%2Fapp_icon.png?alt=media&token=b90f368f-4147-4ab8-8c6f-2a3fe3e98661',
                                      des: '',
                                      ltlg: Ltlg(213.32, 124.3),
                                      time: '9:00 AM',
                                      name: 'Rounak',
                                      uid: 'adkyiasdhkljad',
                                      pId: 'lakdjaljdasdd')),
                              ReusableCard(
                                  pm: PostModel(
                                      url:
                                          'https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/app_icon%2Fapp_icon.png?alt=media&token=b90f368f-4147-4ab8-8c6f-2a3fe3e98661',
                                      des: '',
                                      ltlg: Ltlg(213.32, 124.3),
                                      time: '9:00 AM',
                                      name: 'Rounak',
                                      uid: 'adkyiasdhkljad',
                                      pId: 'lakdjaljdasdd')),
                            ],
                          ),
 */
