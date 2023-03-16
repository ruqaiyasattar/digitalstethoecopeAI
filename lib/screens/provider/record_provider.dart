// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mboathoscope/controllers/sound_recorder.dart';
// import 'package:path_provider/path_provider.dart';
//
// enum RecordingState {
//   UnSet,
//   Set,
//   Recording,
//   Stopped,
// }
//
// class RecordProvider with ChangeNotifier{
//   late RecordingState _recordingState ;
//   late final recorder;
//   bool isRecording = false;
//
//
//   RecordProvider(){
//    _recordingState = RecordingState.UnSet;
//
//     recorder = SoundRecorder();
//   }
//
//
//
// }