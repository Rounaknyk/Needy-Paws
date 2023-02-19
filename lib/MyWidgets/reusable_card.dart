import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/MyWidgets/reusable_icon_text.dart';
import 'package:needy_paw/Screens/adopt_screen.dart';
import 'package:needy_paw/Screens/profile_screen.dart';
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
        if (post["pId"] == widget.pm.pId) {
          await firestore.collection("Posts").doc(post.id).delete();
          await FirebaseStorage.instance.ref("posts/${widget.pm.pId}.jpeg").delete();
          setState(() {});
        }
      }
    }
  }

  Future<void> shareFile() async {
    String link = createDynamicLink(pId: widget.pm.pId) as String;
    // String locationUrl = "google.com/maps/search/${widget.pm.ltlg.lat},+${widget.pm.ltlg.lng}/";
    // Share.share("$link\n*This stray animal needs your help 👇*\n${widget.pm.url}\n\nlocation :\n${locationUrl}");
  }

  Future<Uri> createDynamicLink({required String pId}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: 'https://needypaw.page.link',
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse('https://needypaw.page.link/posts?pId=$pId'),
      androidParameters: AndroidParameters(
        packageName: "com.np.needy_paw",
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.np.needy_paw",
        minimumVersion: '1',
      ),
    );
    final link = await parameters.link;
    // final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    //   link,
    //   DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    // );
    // return shortenedLink.shortUrl;
    Share.share("$link");

    return link;
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
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profilescreen(uid: widget.pm.uid,)));
                        },
                        child: Text(
                          widget.isYours ? "You" : widget.pm.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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