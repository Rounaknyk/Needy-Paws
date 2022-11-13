import 'package:flutter/material.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/Screens/clinic_screen.dart';

import '../Models/Ltlg.dart';

class ClinicCard extends StatelessWidget {
  ClinicCard(
      {required this.cname,
      required this.vname,
      required this.manual_address,
      required this.url,
      required this.ltlg});
  late String cname, vname, manual_address, url;
  late Ltlg ltlg;

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
                  radius: 25,
                  child: ClipRRect(
                    child: Image.network(url),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cname,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          manual_address,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                ReusableButton(
                    text: "Check",
                    func: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClinicScreen(
                                    cm: ClinicModel(
                                        vname: vname,
                                        cname: cname,
                                        manual_address: manual_address,
                                        ltlg: ltlg),
                                  )));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
