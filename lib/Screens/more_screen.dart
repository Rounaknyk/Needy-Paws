import 'package:flutter/material.dart';
import 'package:needy_paw/Screens/clinics_screen.dart';
import 'package:needy_paw/Screens/community_chat_screen.dart';

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableMoreCard(text: "Clinics", func: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ClinicsScreen()));
                    }),
                    SizedBox(width: 20,),
                    ReusableMoreCard(text: "Community", func: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityChatScreen()));
                    }),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableMoreCard(text: "Rescuer", func: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityChatScreen()));
                    }),
                    SizedBox(width: 20,),
                    ReusableMoreCard(text: "Food", func: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityChatScreen()));
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class ReusableMoreCard extends StatelessWidget {

  ReusableMoreCard({required this.text, required this.func});
  late Function func;
  late String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        func();
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),),
          height: 150,
          width: 150,
          child: Center(child: Text(text, style: TextStyle(fontSize: 18),),),
        ),
      ),
    );
  }
}

