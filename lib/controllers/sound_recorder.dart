

import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class SoundRecorder{

  FlutterSoundRecorder? _soundRecorder;
  bool recorderInitialised = false;
  bool get isRecording => _soundRecorder!.isRecording;
  bool get isPlaying => _soundRecorder!.isPaused;

  Future init() async {
    _soundRecorder = FlutterSoundRecorder();
    final permissionStatus = await Permission.microphone.request();
    if(permissionStatus != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone Permission Needed');
    }
    await _soundRecorder!.openRecorder();
    recorderInitialised = true;

  }

  Future dispose() async {
    await _soundRecorder!.closeRecorder();
    _soundRecorder = null;
    recorderInitialised = false;
  }

  Future _record() async {
    if(!recorderInitialised) return;
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    await _soundRecorder!.startRecorder(toFile: filePath);
  }

  Future<dynamic> _stop() async {
    if(!recorderInitialised) return;
    String? url = await _soundRecorder!.stopRecorder();
    return url;
  }

  Future<dynamic> toggleButton() async{
    String? url;
    if(!recorderInitialised) return;

    if(_soundRecorder!.isStopped ){
      url = await _record();
    }
    else{
      url = await _stop();

    }
    return url;
  }
}