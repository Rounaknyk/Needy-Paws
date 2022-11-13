import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/constants.dart';
import 'package:needy_paw/MyWidgets/reusable_textfield.dart';
import 'package:needy_paw/my_routes.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email, pass;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserModel myData;

  signIn(email, pass) async {

    try{
      await auth.signInWithEmailAndPassword(email: email, password: pass);

        final currentUser = auth.currentUser;
        if(currentUser != null){
          String uid = await currentUser.uid;
          final data = await firestore.collection("Users").doc(uid).get();

          setState((){
            myData = UserModel(uid: uid, email: email, name: data["name"], role: data["role"]);
            MyRoutes.myData = myData;
            firestore.collection("Users").doc(uid).set(
                {
                  "name" : myData.name,
                  "email" : myData.email,
                  "uid" : myData.uid,
                  "role" : myData.role
                }
            );
          });
        }
        print("Logged In !");
      Navigator.pushNamed(context, MyRoutes.main);
    }
    catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pets),
        onPressed: () {
          signIn(email, pass);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Hero(
                          tag: "hero_tag",
                          child: Container(
                            height: 200,
                            child: LottieBuilder.asset(animLocationPaw),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ReusabletTextField(
                      hintText: "Enter your email",
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                      getValue: (value) {
                        setState((){
                          email = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ReusabletTextField(
                      isPass: true,
                      hintText: "Enter your password",
                      icon: Icons.password,
                      getValue: (value){
                          setState((){
                            pass = value;
                          });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Text(
                        "Haven't signed up yet ? Sign up here",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.signup);
                      },
                    ),
                  ],
                ),
              ),
              Text(
                "@NeedyPaws",
                style: TextStyle(color: kGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
