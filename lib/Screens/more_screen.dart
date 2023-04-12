import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Screens/ai_chat_screen.dart';
import 'package:needy_paw/Screens/clinics_screen.dart';
import 'package:needy_paw/Screens/community_chat_screen.dart';
import 'package:needy_paw/Screens/pet_stores_screen.dart';
import 'package:needy_paw/Screens/rescuer_screen.dart';
import 'package:needy_paw/Screens/reusable_more_card.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Community
    //Clinics (details of clinics near you)
    //Animal rescuers
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReusableMoreCard(
                  leading: LottieBuilder.asset("Animations/vet.json"),
                  text: "Animal Clinics",
                  hintText: "Contains location of animal clinics in Goa",
                  func: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClinicsScreen()));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ReusableMoreCard(
                  leading: LottieBuilder.asset("Animations/adopter.json"),
                  text: "Rescuers",
                  hintText: "Contains the contacts of animal rescuers",
                  func: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RescuerScreen()));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ReusableMoreCard(
                  leading: LottieBuilder.asset("Animations/group_chat.json"),
                  text: "Community Chat",
                  hintText: "Community chat for animal lovers",
                  func: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityChatScreen()));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ReusableMoreCard(
                  leading: LottieBuilder.asset("Animations/robot.json"),
                  text: "Chat with Max",
                  hintText: "Max is an AI powered chat bot who can answer your questions",
                  func: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AiChatScreen()));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ReusableMoreCard(
                  leading: LottieBuilder.asset("Animations/pet_store.json"),
                  text: "Animal Shops",
                  hintText: "Animal Shops/Stores/Centre are listed here",
                  func: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PetStoresScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}