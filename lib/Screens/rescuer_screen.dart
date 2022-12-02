import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/Models/rescuer_model.dart';
import 'package:needy_paw/MyWidgets/clinic_card.dart';

import '../MyWidgets/rescuer_card.dart';

class RescuerScreen extends StatefulWidget {
  @override
  State<RescuerScreen> createState() => _RescuerScreenState();
}

class _RescuerScreenState extends State<RescuerScreen> {
  late List<RescuerModel> rl = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getData() async {
    final data = await firestore.collection("Rescuers").get();

    for (var d in data.docs) {
      setState(() {
        rl.add(RescuerModel(
            name: d["name"],
            phoneNumber: d["phoneNumber"],
            manual_address: d["manual_address"]));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Rescuers",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: (rl.isNotEmpty)
          ? ListView.builder(
              itemBuilder: (context, index) {
                return RescuerCard(
                  rm: rl[index],
                );
              },
              itemCount: rl.length,
            )
          : Center(
              child: LottieBuilder.asset(
                "Animations/empty.json",
              ),
            ),
    );
  }
}
