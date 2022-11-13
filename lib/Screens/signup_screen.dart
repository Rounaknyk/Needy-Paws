import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/constants.dart';
import 'package:needy_paw/my_routes.dart';
import 'package:needy_paw/MyWidgets/reusable_textfield.dart';

enum roles { user, adopter, vet }

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String email, pass, name;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late UserModel myData;
  var role;
  late String final_role;

  signUp(email, pass) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: pass);
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        String uid = await currentUser.uid;
        setState(() {
          myData = UserModel(uid: uid, email: email, name: name, role: final_role);
          MyRoutes.myData = myData;
          firestore.collection("Users").doc(uid).set(
              {"name": myData.name, "email": myData.email, "uid": myData.uid, "role" : final_role});
          Navigator.pushNamed(context, MyRoutes.main);
        });
      }
    } catch (e) {
      print(e);
    }

    print("Done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pets),
        onPressed: () {
          print("role is : $role");
          if(role == null){
            final scaffold = ScaffoldMessenger.of(context);
            scaffold.showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: const Text('Select a role', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
            );
          }
          else{
            final_role = (role == roles.user) ? "user" : (role == roles.adopter) ? "adopter" : (role == roles.vet) ? "vet" : "none";
            signUp(email, pass);
          }
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Hero(
                          tag: "hero_tag",
                          child: Container(
                            child: LottieBuilder.asset(animLocationPaw),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ReusabletTextField(
                      hintText: "Enter your name",
                      icon: Icons.person,
                      getValue: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ReusabletTextField(
                      hintText: "Enter your email",
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                      getValue: (value) {
                        setState(() {
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
                      getValue: (value) {
                        setState(() {
                          pass = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Select a role", style: TextStyle(fontSize: 20, color: Colors.black),),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          role = roles.user;
                        });
                      },
                      child: Material(
                        elevation: (role == roles.user) ? 10 : 0,
                        borderRadius: BorderRadius.circular(100) ,
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: (role == roles.user) ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(100) ,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "USER",
                                style: TextStyle(color: (role == roles.user) ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          role = roles.adopter;
                        });
                      },
                      child: Material(
                        elevation: (role == roles.adopter) ? 10 : 0,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: (role == roles.adopter) ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "NGO/ADOPTER",
                                style: TextStyle(color: (role == roles.adopter) ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          role = roles.vet;
                        });
                      },
                      child: Material(
                        elevation: (role == roles.vet) ? 10 : 0,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: (role == roles.vet) ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "VET",
                                style: TextStyle(color: (role == roles.vet) ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      child: Text(
                        "Have you already signed up ? Login here",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.login);
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
