// import 'package:flutter_sound_lite/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';

// final pathToSaveAudio = 'audio_exaple.aac';

// class SoundRecorder {
//   FlutterSoundRecorder? _audioRecorder;
//   bool _isRecorderInitialized = false;

//   bool get isRecording => _audioRecorder!.isRecording;

//   Future init() async {
//     _audioRecorder = FlutterSoundRecorder();

//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permission not granted !');
//     }

//     await _audioRecorder!.openAudioSession();
//     _isRecorderInitialized = true;
//   }

//   void dispose() {
//     _audioRecorder!.closeAudioSession();
//     _audioRecorder = null;
//     _isRecorderInitialized = false;
//   }

//   Future record() async {
//     if (!_isRecorderInitialized) return;
//     await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
//   }

//   Future stop() async {
//     if (_isRecorderInitialized) return;
//     await _audioRecorder!.stopRecorder();
//   }

//   Future toggleRecording() async {
//     if (_audioRecorder!.isStopped) {
//       await record();
//     } else {
//       await stop();
//     }
//   }
// }
