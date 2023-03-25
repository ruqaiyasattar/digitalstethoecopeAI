
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';


class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;
  final Directory appDirectory;

  const WaveBubble({
    Key? key,
    required this.appDirectory,
    this.width,
    this.index,
    this.isSender = false,
    this.path,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  File? file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.blueGrey,
    liveWaveColor: Colors.blueAccent,
    scrollScale: 4.0,
    spacing: 5,
  );

  @override
  void initState() {
    super.initState();
    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    // Opening file from assets folder
    if (widget.index != null) {
      file = File('${widget.appDirectory.path}/audio${widget.index}.mp3');
      await file?.writeAsBytes(
          (await rootBundle.load('assets/audios/audio${widget.index}.mp3'))
              .buffer
              .asUint8List());
    }
    if (widget.index == null && widget.path == null && file?.path == null) {
      return;
    }
    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(
      path: widget.path ?? file!.path,
      shouldExtractWaveform: widget.index?.isEven ?? true,
    );
    // Extracting waveform separately if index is odd.
    if (widget.index?.isOdd ?? false) {
      controller
          .extractWaveformData(
        path: widget.path ?? file!.path,

        noOfSamples:
        playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
      )
          .then((waveformData) => debugPrint(waveformData.toString()));
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path != null || file?.path != null
        ? Align(
      alignment:
      widget.isSender ? Alignment.center: Alignment.center,
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
          color: widget.isSender
              ? const Color(0x5ebcc9e5)
              : const Color(0x5ebcc9e5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!controller.playerState.isStopped)
              IconButton(
                onPressed: () async {
                  controller.playerState.isPlaying
                      ? await controller.pausePlayer()
                      : await controller.startPlayer(
                    finishMode: FinishMode.loop,
                  );
                },
                icon: CircleAvatar(
                  maxRadius: 15.0,
                  backgroundColor: Colors.black,
                  child: Icon(
                    controller.playerState.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
                color: Colors.blueAccent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width / 2.2, 50),
              playerController: controller,

              waveformType: widget.index?.isOdd ?? false
                  ? WaveformType.fitWidth
                  : WaveformType.long,
              playerWaveStyle: playerWaveStyle,


            ),
            //..............
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Container(
                child: GestureDetector(
                  onTap: (){},
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.black,

                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0,),
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0,),
            Padding(
              padding: const EdgeInsets.only(right:1,),
              child: Container(
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  child: Image.asset(
                    'assets/images/img_notiblack.png',
                    height: 20,
                    width: 24,
                    color: Colors.black,
                  ),
                ),
                const Positioned(
                  bottom: 19,
                  right: 4,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Color(0xff3D79FD),
                    foregroundColor: Colors.white,
                  ), //CircularAvatar
                ),
              ],
            ),
            SizedBox(width: 5.0,),
            //...............
            // if (widget.isSender) const SizedBox(width: 10),
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}



// class WaveformButton extends StatefulWidget {
//   const WaveformButton({Key? key}) : super(key: key);
//
//   @override
//   State<WaveformButton> createState() => _WaveformButtonState();
// }
//
//
// class _WaveformButtonState extends State<WaveformButton> {
//   late final RecorderController recorderController;
//
//   void _initialiseController() {
//     recorderController = RecorderController()
//       ..androidEncoder = AndroidEncoder.aac
//       ..androidOutputFormat = AndroidOutputFormat.mpeg4
//       ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//       ..sampleRate = 16000;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initialiseController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     late final PlayerController playerController;
//     return Container(
//       margin: const EdgeInsets.all(5.0),
//       padding: const EdgeInsets.all(3.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(40.0),
//         color: const Color(0xffF3F7FF),
//         border: Border.all(color: Colors.black),
//       ),
//       child: Row(
//         children: <Widget>[
//            Expanded(
//             flex: 16,
//             child: Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: CircleAvatar(
//                 maxRadius: 15.0,
//                 backgroundColor: Colors.black,
//                 child: IconButton(
//                     color: Colors.white,
//                     iconSize: 15,
//                     icon: const Icon(
//                         Icons.play_arrow,
//                       color:  Color(0xff3D79FD),
//                     ),
//                     onPressed: () {
//                       // do something
//                     },
//                 ),
//               ),
//             ),
//             ),
//            Expanded(
//             flex: 85,
//             child: AudioWaveforms(
//               enableGesture: true,
//               size: Size(MediaQuery.of(context).size.width, 20.0),
//               recorderController: recorderController,
//               waveStyle: const WaveStyle(
//                 waveColor: Colors.black,
//                 middleLineColor: Colors.black,
//                 showDurationLabel: true,
//                 extendWaveform: true,
//                 showMiddleLine: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

