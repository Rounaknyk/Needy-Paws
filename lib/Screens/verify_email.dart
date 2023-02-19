import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/user_model.dart';
import '../my_routes.dart';

class VerifyEmail extends StatefulWidget {

  VerifyEmail({required this.email, required this.pass, required this.role, required this.name});
  String role, pass, email, name;

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  late UserModel myData;
  bool emailVerified = false;
  late Timer timer;

  Future verifyEmail() async {
    print("reached");
    try {
      final user = auth.currentUser;
      await user?.sendEmailVerification();
      print("sent ${user?.email} ${user?.emailVerified}");
    }
    catch(e){
      print(e);
    }
  }

  checkEmailVerified() async {
    await auth.currentUser?.reload();
    setState(() {
      emailVerified = auth.currentUser?.emailVerified as bool;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailVerified = auth.currentUser?.emailVerified as bool;
    if(!emailVerified){
      verifyEmail();

      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        (_) => checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("A verification link has been sent to your email."),
      ),
    );
  }

}
