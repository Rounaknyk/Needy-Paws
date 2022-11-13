import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton({required this.text, this.color = Colors.blueAccent,required this.func});
  late String text;
  late Color color;
  late Function func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        func();
      },
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        color: color,
        child: Container(
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color),
          height: 50,
          width: 80,
        ),
      ),
    );
  }
}
