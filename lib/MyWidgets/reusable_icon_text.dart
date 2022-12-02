import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReusableIconText extends StatelessWidget {
  ReusableIconText(
      {required this.text, required this.icon, this.color = Colors.black});
  late String text;
  late Color color;
  late Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: icon,
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
            ),
          ),
        ),
      ],
    );
  }
}
