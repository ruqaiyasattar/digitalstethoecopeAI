import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:mboathoscope/controllers/sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../buttons/headerHalf.dart';

class SoundProvider with ChangeNotifier{


  bool isPlaying = false;
  late  bool isSaved ;
   List<String> records = [];
  late Directory appDirectory;
  late final SoundRecorder recorder;
  late RecordingState recordingState;
  late bool isRecording ;

  SoundProvider(){
     isSaved = true;
     recorder = SoundRecorder();
     recordingState = RecordingState.Set;
     isRecording = false;
  }

  setRecordingState(RecordingState recordingState){
    recordingState = recordingState;
    notifyListeners();
  }

  dispose(){
    recordingState = RecordingState.UnSet;
    appDirectory.delete();
    recorder.dispose();
    notifyListeners();
  }

  setIsRecording(){
    isRecording = !isRecording;
    notifyListeners();
  }

   deleteRecord(String path) async {
      try {
        final file = await File(path);
        await file.delete();
      } catch (e) {
        return 0;
      }
      await getRecords();
      notifyListeners();

  }

  setSaved(bool isSave){
    isSaved = isSave;
    notifyListeners();
  }

  bool getSaved ()=> isSaved;

  List<String> getRecord(){

    return records;
  }

   init(){
     recorder.init();
     notifyListeners();
   }



  Future<List> getRecords() async {
     records = [];
    await getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        notifyListeners();
      });
    });
   return records;
  }

  Future onRecordComplete() async {
    // records.clear();
     records = [];
     appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(()  async {
       // records = (records..sort()).reversed.toList();

      isSaved = true;
      recordingState = RecordingState.Set;
       notifyListeners();

     });
    // getRecords();

  }


  Future<void> onRecordButtonPressed() async {
    switch (recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        isSaved = false;
        isRecording = false;
        recordingState = RecordingState.Stopped;
        await recorder.toggleButton();
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        setSaved(true);

        break;
    }
    notifyListeners();
  }

  Future<void> _recordVoice() async {
    recordingState = RecordingState.Recording;
    await recorder.toggleButton();

    // _recordIcon = Icons.stop;
    isRecording = true;
    notifyListeners();

    // }
  }
}