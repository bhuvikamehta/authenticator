import 'package:flutter/material.dart';

class Account extends ChangeNotifier{
  String? secret;
  int? totp;
  String? provi;
  Account({required String s , required String p}){
    secret  =s;
    provi = p;
  }
  int? get getTOTP => totp;
  void setTOTP(int newTOTP){
    totp = newTOTP;
    notifyListeners();
  }
}