
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';


class WaveformButton extends StatefulWidget {
  const WaveformButton({Key? key}) : super(key: key);

  @override
  State<WaveformButton> createState() => _WaveformButtonState();
}


class _WaveformButtonState extends State<WaveformButton> {
  late final RecorderController recorderController;

  late FlutterSoundRecorder _recordingSession;
  final recordingPlayer = AssetsAudioPlayer();

  late String pathToAudio;
  String _timerText = '00:00:00';

  bool _playAudio = false;
  get path => null;

  Future<void> _initialiseController() async {
    pathToAudio = '/Download/temp.wav';
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    await _recordingSession.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _recordingSession.setSubscriptionDuration(const Duration(
        milliseconds: 10));
    await initializeDateFormatting();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();


  }

  @override
  void initState() {
    super.initState();
    _initialiseController();
  }

  @override
  Widget build(BuildContext context) {
    late final PlayerController playerController;

    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: const Color(0xffF3F7FF),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: <Widget>[
           Expanded(
            flex: 16,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                maxRadius: 15.0,
                backgroundColor: Colors.black,
                child: IconButton(
                    color: Colors.white,
                    iconSize: 15,
                    icon: const Icon(
                        Icons.play_arrow,
                      color:  Color(0xff3D79FD),
                    ),
                    onPressed: () {
                      setState(() {
                        _playAudio = !_playAudio;
                      });
                      if (_playAudio) playFunc();
                      if (!_playAudio) stopPlayFunc();
                      // do something
                    },
                ),
              ),
            ),
            ),
           Expanded(
            flex: 85,
            child: AudioWaveforms(
              enableGesture: true,
              size: Size(MediaQuery.of(context).size.width, 20.0),
              recorderController: recorderController,
              waveStyle: const WaveStyle(
                waveColor: Colors.black,
                middleLineColor: Colors.black,
                showDurationLabel: true,
                extendWaveform: true,
                showMiddleLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startRecording() async {
    Directory directory = Directory(path.dirname(pathToAudio));
    if (!directory.existsSync()) {
      directory.createSync();
    }
    _recordingSession.openAudioSession();
    await _recordingSession.startRecorder(
      toFile: pathToAudio,
      codec: Codec.pcm16WAV,
    );
    StreamSubscription recorderSubscription =
    _recordingSession.onProgress.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(
          e.duration.inMilliseconds,
          isUtc: true);
      var timeText = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _timerText = timeText.substring(0, 8);
      });
    });
    recorderSubscription.cancel();
  }

  Future<String> stopRecording() async {
    _recordingSession.closeAudioSession();
    return await _recordingSession.stopRecorder();
  }

  Future<void> playFunc() async {
    recordingPlayer.open(
      Audio.file(pathToAudio),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlayFunc() async {
    recordingPlayer.stop();
  }
  
}

