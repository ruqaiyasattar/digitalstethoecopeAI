import 'package:flutter/material.dart';
import 'package:mboathoscope/buttons/textButton.dart';
import 'package:provider/provider.dart';

import '../screens/provider/sound_provider.dart';

class SaveButton extends StatelessWidget {
  final String txt;
  final Function onPress;

  const SaveButton({
    super.key,
    required this.txt,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);

    return TextButton(
      style: flatButtonStyle,
      onPressed: (){
        onPress();
      },
      child: Text(
        txt,
        style:  TextStyle(
        color:  (soundProvider.getSaved()) ? const Color(0xff3D79FD):Colors.black,
      ),
      ),
    );
  }

}