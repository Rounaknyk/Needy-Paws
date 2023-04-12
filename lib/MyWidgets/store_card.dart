import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/Models/store_model.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/Screens/clinic_screen.dart';

import '../Models/Ltlg.dart';
import '../Screens/pet_store_screen.dart';

class StoreCard extends StatelessWidget {
  StoreCard(
      {required this.name,
      required this.des,
      required this.manual_address,
      required this.url,
      required this.ltlg,
        required this.time,
      required this.phoneNumber});
  late String name, des, manual_address, url, phoneNumber, time;
  late Ltlg ltlg;
  bool loaded = false;

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
                ClipRRect(
                  child: Image.network(
                    url,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: loaded ? 20 : 0,
                      borderRadius: BorderRadius.circular(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: child,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: LottieBuilder.asset(
                      "Animations/paw_loading.json",
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                  );
                }
              },
            ),
                  borderRadius: BorderRadius.circular(10),),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            manual_address,
                            maxLines: 1,
                            style: TextStyle(fontSize: 13),
                          ),
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
                              builder: (context) => PetStoreScreen(
                                    sm: StoreModel(
                                        des: des,
                                        name: name,
                                        manual_address: manual_address,
                                        ltlg: ltlg,
                                        phoneNumber: phoneNumber,
                                        url: url, time: '', uid: '', storeId: '',),
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
