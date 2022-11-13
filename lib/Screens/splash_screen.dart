import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/constants.dart';
import 'package:needy_paw/my_routes.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late UserModel myData;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      hasLoggedIn(context);
    });
  }

  hasLoggedIn(BuildContext context) async {
    if(auth.currentUser != null){
      final uid = auth.currentUser?.uid;
      final data = await firestore.collection("Users").doc(uid).get();
      myData = UserModel(name: data["name"], email: data["email"], uid: uid.toString(), role: data["role"]);
      MyRoutes.myData = myData;
      Navigator.pushNamed(context, MyRoutes.main);
    }
    else{
      Navigator.pushNamed(context, MyRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Hero(
                tag: "hero_tag",
                child: Container(
                  height: 500,
                  child: LottieBuilder.asset(animLocationPaw),
                ),
              ),
            ),
            GestureDetector(onTap: (){
              Navigator.pushNamed(context, MyRoutes.signup);
            }, child: Text("NEEDY PAW'S", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, ),)),
          ],
        ),
      ),
    );
  }
}
