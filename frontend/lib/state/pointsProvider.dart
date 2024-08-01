import 'package:flutter/material.dart';

class PointsProvider extends ChangeNotifier {

  String? _roomId;
  Map<String?, Map<String?, int>> roomPoints = {};

  String? get roomId {
    return _roomId;
  }

  void setRoomId(String? roomId) {
    _roomId = roomId;
  }

  void updatePoints(String? email, int points){
    if(!roomPoints.containsKey(_roomId)){
      roomPoints[_roomId] = {};
      roomPoints[_roomId]![email] = points;
    }
  }

  Map<String?, int>? getPoints(String? roomId){
    return roomPoints[roomId];
  }
  
}

