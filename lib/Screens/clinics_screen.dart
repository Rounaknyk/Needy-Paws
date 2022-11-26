import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/Screens/map_screen2.dart';

import '../Models/Ltlg.dart';
import '../MyWidgets/clinic_card.dart';

class ClinicsScreen extends StatefulWidget {
  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late ClinicModel cm;
  List<ClinicCard> clinicList = [];
  List<LatLng> latlngs = [];
  List<ClinicModel> cList = [];

  getClinics() async {
    clinicList.clear();
    final data = await firestore.collection("Clinics").get();
    // data[0]["cname"];
    for (var clinic in data.docs) {
      setState(() {
        cm = ClinicModel(
            vname: clinic["vname"],
            cname: clinic["cname"],
            manual_address: clinic["manual_address"],
            ltlg: Ltlg(clinic["latitude"], clinic["longitude"]),
            url: clinic["url"],
            phoneNumber: clinic["phoneNumber"]);
        clinicList.add(
          ClinicCard(
            cname: cm.cname,
            vname: cm.vname,
            manual_address: cm.manual_address,
            url: cm.url,
            ltlg: cm.ltlg,
            phoneNumber: cm.phoneNumber,
          ),
        );
        cList.add(cm);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClinics();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text("Clinics", style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(icon: Icon(Icons.map_outlined, color: Colors.black,), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen2(cList: cList)));
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: clinicList.length,
            itemBuilder: (context, index) {
              return clinicList[index];
            },
          ),
        ),
      ),
    );
  }
}
