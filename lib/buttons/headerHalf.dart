import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:mboathoscope/buttons/SaveButton.dart';
import 'package:mboathoscope/screens/provider/sound_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../controllers/sound_recorder.dart';

class headerHalf extends StatefulWidget {
   headerHalf({ Key? key, required this.onRecord,}) : super(key: key);

   final Function onRecord;
  @override
  State<headerHalf> createState() => _headerHalfState();
}
enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}
class _headerHalfState extends State<headerHalf> {


  late  SoundProvider provider;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      provider = Provider.of<SoundProvider>(context, listen: false);
      await provider.init();
    });
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 34.0,left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/images/img_head.png',
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(
                width: 150,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Image.asset(
                            'assets/images/img_notiblack.png',
                            height: 30,
                            width: 32,
                            color: const Color(0xff3D79FD),
                          ),
                        ),
                         const Positioned(
                          bottom: 0.02,
                          right: 3,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(
                                0xff3D79FD),
                            foregroundColor: Colors.white,
                          ), //CircularAvatar
                        ),
                      ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(
              right: 8.0,
              left: 8.0,
              top: 20.0,
              bottom: 20.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                  //padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Stack(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/img_round.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/img_heart.png',
                                height: 25,
                                width: 25,
                              ),
                              const Text(
                                  'heart',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              GestureDetector(
                onTap: (){
                  soundProvider.setIsRecording();
                  soundProvider.onRecordButtonPressed();
                },
                child: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: (soundProvider.isRecording ) ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xff3D79FD),
                            borderRadius: BorderRadius.circular(100)
                          ),
                            child: Icon(Icons.mic,size: 70,color: Colors.white,)):Image.asset(
                          'assets/images/img_record.png',
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 17.0, right: 17.0),
                  child: SaveButton(
                    txt: 'Save', onPress:widget.onRecord,

                  ),
                ),
              ),
            ],
          ),
        ),
        const Text(
          'Press and hold the button to transmit the sound',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        const Padding(
          padding:  EdgeInsets.only(top: 20.0, bottom: 35.0, left: 35.0, right: 35.0),
          child: Text(
            'Please ensure that you are wearing noise cancelling headphones',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
             Padding(
               padding: EdgeInsets.only(left: 18.0, top: 25.0),
               child: Text(
                'Recordings',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
               ),
             ),
          ],
        ),
      ],
    );
  }


}
