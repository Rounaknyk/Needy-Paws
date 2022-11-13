import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String des = "";
  String infection = "none";
  String manual_address = "none";
  late String vname, cname, uid;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/Clinics%2Fclinic.png?alt=media&token=bd396ada-54e4-4e01-9bdc-d746e916f0e2";
  Widget textOrImage = Text("Tap here to upload");
  late Ltlg ltlg;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  UploadTask? uploadTask;
  ImagePicker picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future uploadData() async {
    if(auth.currentUser != null){
      uid = auth.currentUser!.uid;
      final upload = await firestore.collection("Clinics").doc().set({
        "vname" : vname,
        "cname" : cname,
        "manual_address" : manual_address,
        "latitude" : ltlg.lat,
        "longitude" : ltlg.lng,
        "url" : url
      });
    }

  }

  selectImage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add your clinic"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadData();
        },
        child: Icon(Icons.pets),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Align(child: Text("Vet's details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),), alignment: AlignmentDirectional.topStart,),
              SizedBox(height: 10,),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    vname = newValue;
                  });
                },
                hintText: "Vet's name",
                icon: Icons.person,
              ),
              SizedBox(height: 20,),
              Align(child: Text("Clinic's details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),), alignment: AlignmentDirectional.topStart,),
              SizedBox(height: 10,),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    cname = newValue;
                  });
                },
                hintText: "Clinic name",
                icon: Icons.other_houses,
              ),
              SizedBox(height: 10,),
              ReusabletTextField(
                getValue: (newValue) {
                  setState(() {
                    manual_address = newValue;
                  });
                },
                hintText: "Clinic's manual address",
                icon: Icons.location_on,
              ),
              SizedBox(height: 10,),
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
