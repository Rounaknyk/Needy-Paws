import 'package:flutter/material.dart';
import 'package:needy_paw/Models/Ltlg.dart';

class PostModel{

  late String name, url, des, infection, time, manual_address, uid;
  late Ltlg ltlg;

  PostModel({required this.url, required this.des, required this.ltlg, required this.time ,this.infection = "none", this.manual_address = "none", required this.name, required this.uid});

}