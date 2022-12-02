import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../Models/Ltlg.dart';
import '../MyWidgets/reusable_textfield.dart';
import 'map_screen.dart';

/*
Vet's name
Clinic's name
Manual address
Location with Map
Clinic's pic (optional)
 */

class AddClinicScreen extends StatefulWidget {
  const AddClinicScreen({Key? key}) : super(key: key);

  @override
  State<AddClinicScreen> createState() => _AddClinicScreenState();
}

class _AddClinicScreenState extends State<AddClinicScreen> {
  String manual_address = "none";
  String phoneNumber = "none";
  late String uid;
  String vname = "", cname = "";
  File? fi;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/Clinics%2Fclinic.png?alt=media&token=bd396ada-54e4-4e01-9bdc-d746e916f0e2";
  Widget textOrImage = Text("Tap here to upload");
  Ltlg ltlg = Ltlg(0.0, 0.0);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  UploadTask? uploadTask;
  ImagePicker picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future uploadData() async {
    if (auth.currentUser != null) {
      uid = auth.currentUser!.uid;
      final upload = await firestore.collection("Clinics").doc().set({
        "vname": vname,
        "cname": cname,
        "manual_address": manual_address,
        "latitude": ltlg.lat,
        "longitude": ltlg.lng,
        "url": url,
        "phoneNumber": phoneNumber
      });
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);

    }
  }

  Future uploadPost() async {
    isLoading = true;

    try {
      final data = storage.ref("clinics").child(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

      uploadTask = data.putFile(fi!);

      final snapshot = await uploadTask?.whenComplete(() => () {});

      url = (await snapshot?.ref.getDownloadURL())!;
      uploadData();
    }
    catch(e){
      print(e);
    }

  }

  Future selectImage() async {
    try {
      final files =
      await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (files == null) {
        print("object null");
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
    print("$vname $cname $fi $ltlg $phoneNumber $manual_address");

    if(vname == "" || vname == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Please enter the vet\'s name",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),);
      return false;
    }

    if(phoneNumber == null || phoneNumber == "none"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Please enter a phonenumber',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),);
      return false;
    }

    if(cname == null || cname == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Please enter the clinic name',
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

    if(ltlg.lng == 0.0){
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
        title: Text("Add your clinic"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(isValid())
          uploadPost();

        },
        child: isLoading ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: LottieBuilder.asset("Animations/paw_loading.json"),
        ) : Icon(Icons.pets),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
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
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                child: Text(
                  "Vet's details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                alignment: AlignmentDirectional.topStart,
              ),
              SizedBox(
                height: 10,
              ),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    vname = newValue;
                  });
                },
                hintText: "Vet's name",
                icon: Icons.person,
              ),
              SizedBox(
                height: 10,
              ),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    phoneNumber = newValue.toString();
                  });
                },
                hintText: "Phone number",
                icon: Icons.call,
                textInputType: TextInputType.phone,
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                child: Text(
                  "Clinic's details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                alignment: AlignmentDirectional.topStart,
              ),
              SizedBox(
                height: 10,
              ),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    cname = newValue;
                  });
                },
                hintText: "Clinic name",
                icon: Icons.other_houses,
              ),
              SizedBox(
                height: 10,
              ),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    manual_address = newValue;
                  });
                },
                hintText: "Clinic's manual address",
                icon: Icons.location_on,
              ),
              SizedBox(
                height: 10,
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
            ],
          ),
        ),
      ),
    );
  }
}

/*
Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadData();
        },
        child: Icon(Icons.pets),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 100,
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectImage();
                        textOrImage = Image.network(url);
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
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            ],
          ),
        ),
      ),
    );
 */
