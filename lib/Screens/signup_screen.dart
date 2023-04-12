import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  String otpText = "";
  late EmailAuth emailAuth;
  Widget otpWidget = Text("");
  bool otpVerified = false;
  bool isLoading = false;
  String userToken = "";

  signUp(String email, String pass) async {

    setState(() {
      isLoading = true;
    });

    final scaffold = ScaffoldMessenger.of(context);

    if (pass.length < 6) {
      scaffold.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text(
            'Password should be atleast of 6 characters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }
    if (!email.contains("@gmail.com")) {
      scaffold.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text(
            'The email is badly formatted',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: pass);
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        String uid = await currentUser.uid;
        setState(() {
          myData =
              UserModel(uid: uid, email: email, name: name, role: final_role);
          MyRoutes.myData = myData;
          firestore.collection("Users").doc(uid).set({
            "name": myData.name,
            "email": myData.email,
            "uid": myData.uid,
            "role": final_role,
            "token": userToken
          });
          Navigator.pushNamed(context, MyRoutes.main);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmail(email: email, pass: pass, role: role.toString(), name: name)));
        });
      }
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${e.toString()}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });

  }


  Future<String> getAndSetToken() async {
    print("reached ${myData.uid}");
    try {
      await FirebaseMessaging.instance.getToken().then((token) {
        setState(() {
          userToken = token!;
        });
      });
      return userToken;

    }
    catch (e) {
      print("COOOOOOL $e");
    }
    return "";
  }

  //
  // verifyEmail(){
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmail(email: email, pass: pass, role: role, name: name)));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      userToken = await getAndSetToken();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: isLoading ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: LottieBuilder.asset("Animations/paw_loading.json"),
          ) : Icon(Icons.pets),
          onPressed: () {
            if (role == null) {
              final scaffold = ScaffoldMessenger.of(context);
              scaffold.showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: const Text(
                    'Select a role',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              final_role = (role == roles.user)
                  ? "user"
                  : (role == roles.adopter)
                      ? "adopter"
                      : (role == roles.vet)
                          ? "vet"
                          : "none";
              signUp(email, pass);
              // verifyEmail();
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    ),
                    ReusabletTextField(
                      hintText: "Username / Organisation name",
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
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
                    Text(
                      "Select a role",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          role = roles.user;
                        });
                      },
                      child: Material(
                        elevation: (role == roles.user) ? 10 : 0,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: (role == roles.user)
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "USER/ORGANISATION",
                                style: TextStyle(
                                    color: (role == roles.user)
                                        ? Colors.white
                                        : Colors.black),
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
                            color: (role == roles.adopter)
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "ADOPTER",
                                style: TextStyle(
                                    color: (role == roles.adopter)
                                        ? Colors.white
                                        : Colors.black),
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
                            color: (role == roles.vet)
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "VET",
                                style: TextStyle(
                                    color: (role == roles.vet)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Text(
                        "Have you already signed up ? SignIn here",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.login);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "@NeedyPaws",
                      style: TextStyle(color: kGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

