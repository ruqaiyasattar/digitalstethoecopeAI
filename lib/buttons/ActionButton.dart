
import 'package:flutter/material.dart';
import 'package:mboathoscope/buttons/textButton.dart';

class ActionButton extends StatelessWidget {
  final String txt;
  final Function onPress;
  final Color color;

  const ActionButton({
    super.key,
    required this.txt,
    required this.onPress,
    required this.color
  });

  @override
  Widget build(BuildContext context) {

    return TextButton(
      style: color==Colors.red?flatButtonStyleRed:flatButtonStyle,
      onPressed: (){
        onPress();
      },
      child: Text(
        txt,
        style: TextStyle(
        color:  color,
      ),
      ),
    );
  }

}