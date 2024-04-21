class ButtonState {
  String character;
  bool isPressed = false;
  int correctState = -1;

  ButtonState(
      {required this.character,
      required this.isPressed,
      required this.correctState});
}

const maxLapTime = 90;