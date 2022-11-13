import 'package:flutter/material.dart';
import 'package:needy_paw/Models/Ltlg.dart';

class ClinicModel{

  late String vname, cname, manual_address, url;
  late Ltlg ltlg;

  ClinicModel({required this.vname, required this.cname, required this.manual_address, required this.ltlg, this.url = "https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/Clinics%2Fclinic.png?alt=media&token=bd396ada-54e4-4e01-9bdc-d746e916f0e2"});
}