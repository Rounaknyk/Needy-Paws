import 'package:flutter/material.dart';
import 'package:needy_paw/Models/Ltlg.dart';

class StoreModel{

  late String name, url, des, time, manual_address, uid, storeId, phoneNumber;
  late Ltlg ltlg;

  StoreModel({required this.url,this.des = 'No description was entered', required this.ltlg, required this.time, this.manual_address = "none", required this.name, required this.uid, required this.storeId, this.phoneNumber = ''});

}