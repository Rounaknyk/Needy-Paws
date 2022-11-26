import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/Screens/chat_screen.dart';
import 'package:needy_paw/Screens/clinic_screen.dart';

import '../Models/Ltlg.dart';

class ChatListCard extends StatelessWidget {
  ChatListCard(
      {required this.name, required this.email, required this.uid, required this.role});
  late String name, email, uid, role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderUid: uid, senderName: name)));
        },
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: ClipRRect(
                      child: (role == "user") ? LottieBuilder.asset("Animations/profile.json")
                          : ( (role == "adopter") ? LottieBuilder.asset("Animations/adopter.json")
                          : (role == "vet") ? LottieBuilder.asset("Animations/vet.json") : null ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${role.toUpperCase()}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
