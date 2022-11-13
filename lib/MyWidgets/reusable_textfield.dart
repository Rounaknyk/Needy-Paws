import 'package:flutter/material.dart';

class ReusabletTextField extends StatefulWidget {

  ReusabletTextField({this.hintText, this.icon ,this.isPass = false, this.textInputType = TextInputType.text,required this.getValue});
  bool isPass;
  String? hintText;
  IconData? icon;
  TextInputType textInputType;
  Function getValue;

  @override
  State<ReusabletTextField> createState() => _ReusabletTextFieldState();
}

class _ReusabletTextFieldState extends State<ReusabletTextField> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
        child: TextField(
          controller: controller,
        onChanged: (value){
          widget.getValue(value);
        },
        keyboardType: widget.textInputType,
        obscureText: widget.isPass,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}