import 'package:flutter/material.dart';
import 'package:mboathoscope/Utils/Helpers.dart';

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  //primary:  Colors.white,
  //minimumSize: const Size(15, 46),
  textStyle: const TextStyle(
    //color: Color(0xffF3F7FF),
  ),

  //padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: RoundedRectangleBorder(
    side: BorderSide(
      color:  Helpers.appBlueColor,
      width: 1,
      style: BorderStyle.solid
  ),
    borderRadius: BorderRadius.circular(25),
  ),
  backgroundColor: const Color(0xffF3F7FF),
);


final ButtonStyle flatButtonStyleRed = TextButton.styleFrom(
  //primary:  Colors.white,
  //minimumSize: const Size(15, 46),
  textStyle: const TextStyle(
    //color: Color(0xffF3F7FF),
  ),

  //padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: RoundedRectangleBorder(
    side: const BorderSide(
        color:  Colors.red,
        width: 1,
        style: BorderStyle.solid
    ),
    borderRadius: BorderRadius.circular(25),
  ),
  backgroundColor: const Color(0xffF3F7FF),
);
