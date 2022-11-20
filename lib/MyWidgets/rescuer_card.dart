import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:needy_paw/Models/rescuer_model.dart';

import '../Models/Ltlg.dart';
import '../Models/clinic_model.dart';
import 'reusable_button.dart';
import '../Screens/clinic_screen.dart';

class RescuerCard extends StatefulWidget {
  RescuerCard(
      {required this.rm});
  late RescuerModel rm;

  @override
  State<RescuerCard> createState() => _RescuerCardState();
}

class _RescuerCardState extends State<RescuerCard> {
  Future callNumber(phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber("+91$phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.white, size: 40,),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.rm.name,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.rm.manual_address,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      callNumber(widget.rm.phoneNumber);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
