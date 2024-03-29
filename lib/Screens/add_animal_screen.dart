import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Classes/get_time.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/Models/post_model.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'dart:io';
import 'package:needy_paw/MyWidgets/reusable_textfield.dart';
import 'package:needy_paw/Screens/map_screen.dart';
import 'package:needy_paw/my_routes.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Classes/get_post_time.dart';

class AddAnimalScreen extends StatefulWidget {
  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  late File file;
  String des = "";
  String infection = "none";
  String manual_address = "none";
  late String name, uid;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/posts%2Fdeveloper.jpeg?alt=media&token=b92f309f-f06e-4d33-8b25-3b7220ca4f2d";
  Widget textOrImage = Text("Tap here to upload");
  Ltlg ltlg = Ltlg(0.0, 0.0);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  UploadTask? uploadTask;
  late File image;
  late PostModel pm;
  ImagePicker picker = ImagePicker();
  File? fi;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  String token = "", pId = "000000000";

  uploadPost() async {
    setState((){
      pId = DateTime.now().millisecondsSinceEpoch.toString();
      isLoading = true;
    });

    try {
      final data = storage
          .ref()
          .child("posts")
          .child(pId);
      uploadTask = data.putFile(fi!);
      final snapshot = await uploadTask?.whenComplete(() => () {});
      url = (await snapshot?.ref.getDownloadURL())!;
      print(url);
      uploadData();
    } catch (e) {
      print(url);
    }
  }

  getNameUid() async {
    if (auth.currentUser != null) {
      final data =
          await firestore.collection("Users").doc(auth.currentUser!.uid).get();
      name = data["name"];
      uid = data["uid"];
      token = data["token"];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationPermission();
    getNameUid();
  }

  getLocationPermission() async {
    Location loc = Location();
    await loc.getLocation();
  }

  uploadData() async {
    pm = PostModel(
        url: url,
        des: des,
        ltlg: ltlg,
        time: GetPostTime().getTime(context, DateTime.now()),
        infection: (infection == "") ? "none" : infection,
        manual_address: manual_address,
        name: name,
        uid: uid,
        pId: pId,
        token: token);

    try {
      await firestore.collection("Posts").doc(pm.pId).set({
        "des": pm.des,
        "url": pm.url,
        "lat": pm.ltlg.lat,
        "lng": pm.ltlg.lng,
        "time": pm.time,
        "infection": pm.infection,
        "manual_address": pm.manual_address,
        "name": pm.name,
        "uid": pm.uid,
        "pId" : pm.pId,
        "token" : pm.token
      });

      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, MyRoutes.main);
      // selectImg();
      // uploadPost();
    } catch (e) {
      print(e);
    }
  }

  Future selectImage() async {

      try {
        final files =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
        if (files == null) {
          return;
        }
        fi = File(files.path);
        setState(() {
          textOrImage = Image.file(fi!);
        });
      } catch (e) {
        print(e);
      }

    // FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.media);
    // print(result);
  }

  bool isValid(){
     if(fi == null){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         backgroundColor: Colors.red,
         content: Text(
           'Please select an image',
           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
         ),
       ),);
       return false;
     }

    if(des == "" || des == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Description cannot be empty',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),);
      return false;
    }

    if(manual_address == "none" || manual_address == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Manual Address cannot be empty',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),);
      return false;
    }

    if(ltlg.lat == 0.0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Please select a location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),);
      return false;
    }

    return true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Post"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(isLoading){
            return;
          }
          if(isValid())
          uploadPost();
        },
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: LottieBuilder.asset("Animations/paw_loading.json"),
              )
            : Icon(Icons.pets),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectImage();
                      });
                      // selectPic();
                    },
                    child: Card(
                      borderOnForeground: true,
                      color: Colors.white,
                      child: Center(
                        child: textOrImage,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Description"),
                SizedBox(
                  height: 20,
                ),
                ReusabletTextField(
                  getValue: (value) {
                    setState(() {
                      des = value;
                    });
                  },
                  hintText: "Enter the description",
                  icon: Icons.description,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Location"),
                SizedBox(
                  height: 20,
                ),
                ReusabletTextField(
                  getValue: (value) {
                    manual_address = value;
                  },
                  hintText: "Manual Address (optional)",
                  icon: Icons.location_on,
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    ltlg = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(),
                      ),
                    );
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Tap to set location",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Is it infected ? (optional)"),
                SizedBox(
                  height: 20,
                ),
                ReusabletTextField(
                  getValue: (value) {
                    setState(() {
                      infection = value;
                    });
                  },
                  hintText: "Leave this blank if none",
                  icon: Icons.coronavirus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
