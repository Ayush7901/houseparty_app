import 'dart:core';
import 'package:flutter/material.dart';

class PlayerProvider extends ChangeNotifier{
  String _username = "";
  int? _currPoints;

  String? get username => _username;
  int? get currPoints => _currPoints;

  void setUserName(String username){
    _username = username;
  }
}