// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ButtonState {
  String character;
  bool isPressed = false;
  int correctState = -1;

  ButtonState(
      {required this.character,
      required this.isPressed,
      required this.correctState, required });
  
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'character': character,
      'isPressed': isPressed,
      'correctState': correctState,
    };
  }

factory ButtonState.fromMap(Map<String, dynamic> map) {
    return ButtonState(
      character: map['character'] as String,
      isPressed: map['isPressed'] as bool,
      correctState: map['correctState'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ButtonState.fromJson(String source) => ButtonState.fromMap(json.decode(source) as Map<String, dynamic>);
}

const maxLapTime = 30;






