import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';


class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final num recordingNumber;  
  final String? path;
  final double? width;
  final Directory appDirectory;

  const WaveBubble({
    Key? key,
    required this.appDirectory,
    this.width,
    this.index,
    required this.recordingNumber ,
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
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
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
                const SizedBox(width: 5.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5.0,),
                Padding(
                  padding: const EdgeInsets.only(right:1,),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: const Icon(
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
                const SizedBox(width: 3.0,),
                //...............
                // if (widget.isSender) const SizedBox(width: 10),
              ],
            ),
          ),
          Text(
            "Recording number ${widget.recordingNumber}",
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          ),
          const SizedBox(height: 3,)

        ],
      ),
    )
        : const SizedBox.shrink();
  }
}


