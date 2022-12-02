import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/MyWidgets/reusable_icon_text.dart';
import 'package:needy_paw/Screens/adopt_screen.dart';
import 'package:share/share.dart';

import '../Models/post_model.dart';

class ReusableCard extends StatefulWidget {
  ReusableCard({required this.pm, this.isYours = true});
  late PostModel pm;
  bool isYours = true;

  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loaded = false;
  bool isInfected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.pm.url);
    widget.isYours = (auth.currentUser!.uid == widget.pm.uid);

    isInfected = (widget.pm.infection == "none") ? false : true;
  }

  deletePost() async {
    String uid = auth.currentUser!.uid;
    if (widget.pm.uid == uid) {
      final posts = await firestore.collection("Posts").get();
      for (var post in posts.docs) {
        if (post["lat"] == widget.pm.ltlg.lat &&
            post["lng"] == widget.pm.ltlg.lng) {
          await firestore.collection("Posts").doc(post.id).delete();
          setState(() {});
        }
      }
    }
  }

  Future<void> shareFile() async {
    String locationUrl = "google.com/maps/search/${widget.pm.ltlg.lat},+${widget.pm.ltlg.lng}/";
    Share.share("*This stray animal needs your help 👇*\n${widget.pm.url}\n\nlocation :\n${locationUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        widget.isYours ? "You" : widget.pm.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "at ${widget.pm.time}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.network(
                      widget.pm.url,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: loaded ? 20 : 0,
                              borderRadius: BorderRadius.circular(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: child,
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: LottieBuilder.asset(
                              "Animations/paw_loading.json",
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ReusableIconText(
                        text: widget.pm.des,
                        icon: SvgPicture.asset(
                          "svgs/des.svg",
                          height: 24,
                          width: 24,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableIconText(
                      text: widget.pm.manual_address,
                      //city location
                      icon: SvgPicture.asset(
                        "svgs/location.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableIconText(
                        text: widget.pm.infection,
                        icon: SvgPicture.asset(
                          "svgs/coronavirus.svg",
                          height: 24,
                          width: 24,
                          color: isInfected ? Colors.red : Colors.black,
                        ),
                        color: (widget.pm.infection != "none")
                            ? Colors.red
                            : Colors.black),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: widget.isYours
              ? ReusableButton(
                  text: "Delete",
                  color: Color(0XFFDE4E4F),
                  func: () {
                    deletePost();
                  })
              : ReusableButton(
                  text: "Adopt",
                  func: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdoptScreen(pm: widget.pm)));
                  }),
          bottom: 30,
          right: 30,
        ),
        Positioned(
          child: Row(
            children: [
              IconButton(
                onPressed: (){
                  shareFile();
              }, icon: Icon(Icons.share),),
              SizedBox(width: 10,),
              isInfected ? LottieBuilder.asset(
                "Animations/virus.json",
                height: 50,
                width: 50,
              ) : SvgPicture.asset(
                "svgs/shield.svg",
                height: 30,
                width: 30,
              ),
            ],
          ),
          top: 30,
          right: 30,
        ),
      ],
    );
  }
}

/*
Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(20),
            child: Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Icon(
                                  Icons.share,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Icon(
                                  Icons.chat_bubble,
                                  size: 30,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(pm.name),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(pm.manual_address),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.description),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(pm.des),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.coronavirus,
                                    color: (pm.infection != "none")
                                        ? Colors.red
                                        : Colors.black),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      pm.infection,
                                      style: TextStyle(
                                          color: (pm.infection != "none")
                                              ? Colors.red
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Align(child: Text("$des"), alignment: AlignmentDirectional.topStart,),
                            // SizedBox(height: 10,),
                            // Align(child: Text("Infection : ${infection}"), alignment: AlignmentDirectional.topStart,),
                            // SizedBox(height: 10,),
                            // Align(child: Text("Location : Downing streets"), alignment: AlignmentDirectional.topStart,),
                            // SizedBox(height: 40,),
                            // Align(child: Text("* Click on the location icon to locate the animal *", style: TextStyle(fontSize: 14),), alignment: AlignmentDirectional.topStart,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          //fix this hard coded things
          // height: (MediaQuery.of(context).size.height * 0.5) * 0.6,
          height: 300,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: ClipRRect(
              child: Image.asset(
                "Assets/street_dog.jpeg",
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 50,
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 50,
          right: 50,
          child: Align(
              child: ReusableButton(text: "Adopt", func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdoptScreen(pm: pm,),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
 */
