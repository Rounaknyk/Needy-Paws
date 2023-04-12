import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReusableMoreCard extends StatelessWidget {

  ReusableMoreCard({required this.leading, required this.text, required this.func, this.hintText = ""});
  late Function func;
  late String text, hintText;
  Widget leading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        func();
      },
      child: SingleChildScrollView(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: leading,
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text(hintText,),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
