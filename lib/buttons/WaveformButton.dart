
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/screens/provider/sound_provider.dart';
import 'package:provider/provider.dart';


class WaveformButton extends StatefulWidget {
   WaveformButton({ required this.isPlaying,required this.onPlay, Key? key, required this.record, required this.i}) : super(key: key);
  Function onPlay;
  final int i;
  final bool isPlaying;
   String record;
   @override
  State<WaveformButton> createState() => _WaveformButtonState();
}


class _WaveformButtonState extends State<WaveformButton> {
  late final RecorderController recorderController;
  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    super.initState();
    _initialiseController();
  }
  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
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
                    icon: widget.isPlaying ? Icon(
                      Icons.pause,
                      color:  Color(0xff3D79FD),
                    ):Icon(
                        Icons.play_arrow,
                      color:  Color(0xff3D79FD),
                    ),
                    onPressed: () async {

                      await widget.onPlay(playerController:recorderController,
                          filePath: widget.record, index: widget.i);

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
}
/*

void _startRecording() async {
  await recorderController.record(path);
  // update state here to, for eample, change the button's state
}
void _stopRecording() async {
  final path = await recorderController.stop();
}*/
