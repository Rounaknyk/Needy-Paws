import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needy_paw/Models/Ltlg.dart';
import 'package:needy_paw/MyWidgets/clinic_card.dart';
import 'package:needy_paw/MyWidgets/store_card.dart';
import 'package:needy_paw/Screens/add_animal_screen.dart';

import '../Models/store_model.dart';
import 'add_store_screen.dart';

class PetStoresScreen extends StatefulWidget {

  @override
  State<PetStoresScreen> createState() => _PetStoresScreenState();
}

class _PetStoresScreenState extends State<PetStoresScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid;
  late StoreModel sm;

  _addStore(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddStoreScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = auth.currentUser!.uid;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        _addStore();
      }, child: Icon(Icons.add_home_work_rounded, color: Colors.white,),),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('Stores').snapshots(),
          builder: (context, snapshot){
            List<StoreCard> storeList = [];

            if(snapshot.hasData){
              final stores = snapshot.data?.docs;
              storeList.clear();
              for(var store in stores!){
                sm = StoreModel(url: store['url'], des: store['des'], ltlg: Ltlg(store['lat'], store['lng']), time: store['time'], name: store['name'], uid: store['uid'], storeId: store['storeId'], phoneNumber: store['phoneNumber'], manual_address: store['manual_address']);
                storeList.add(StoreCard(name: sm.name, des: sm.des, manual_address: sm.manual_address, url: sm.url, ltlg: sm.ltlg, phoneNumber: sm.phoneNumber, time: store['time'],));
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
          return ListView.builder(itemBuilder: (context, index){
            return storeList[index];
          }, itemCount: storeList.length,);
        }),
      ),
    );
  }
}
