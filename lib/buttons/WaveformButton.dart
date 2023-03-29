

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import '../Utils/Helpers.dart';


class WaveformButton extends StatefulWidget {
  final PlayerController playerController;
  const WaveformButton({Key? key, required this.playerController}) : super(key: key);

  @override
  State<WaveformButton> createState() => _WaveformButtonState();
}


class _WaveformButtonState extends State<WaveformButton> {
  late final PlayerController playerController; ///Recording Player
  late bool isPlaying; ///state of recording player
  late Duration duration; ///Duration of recording
  static int millisecondsInAnHour = 3600000; ///Equivalence of milliseconds in an hour



  @override
  void initState() {
    super.initState();

    ///Sets recording's player state to not playing upon page initialization
    isPlaying = false;

    ///sets the locally declared player to the pass player from the recordings Class
    playerController = widget.playerController;

    ///Initializes the duration of the player's maximum duration
    duration = Duration(milliseconds: playerController.maxDuration);

    ///Used to listen and update duration during the cause of playing
    playerController.onCurrentDurationChanged.listen((event) {
      setState(() {
        duration = Duration(milliseconds: event);
      });
    });

    ///Gets player completion event and use to trigger player to
    ///pause when entire audio has been listened
    playerController.onCompletion.listen((event) {
      setState(() {
        ///Set playing to not playing since player has reached its end
        isPlaying = !isPlaying;
      });
    });
  }




  @override
  void dispose() {
    super.dispose();
    ///Removes all listeners associated to a player
    playerController.removeListener((){});

    ///Stop players since it will no longer be played
    playerController.stopPlayer();

    ///Causes an error/audio leaks so removed,
    ///will investigate later on what causes this
    // playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      maxRadius: 15.0,
                      backgroundColor: Colors.black,
                      child: IconButton(
                          color: Colors.white,
                          iconSize: 15,
                          icon: isPlaying ? Icon(Icons.pause, color:  Helpers.appBlueColor):
                          Icon(Icons.play_arrow, color:  Helpers.appBlueColor,),
                          onPressed: () {

                            try{

                              if(isPlaying){
                                ///pause player without freeing resources hence allow replay/continue
                                playerController.pausePlayer();

                              }else{
                                ///FinishMode.pause: Allows audio to replayed several times starting from 0 second
                                playerController.startPlayer(finishMode: FinishMode.pause);
                              }

                              ///Toggls between playing and not playing
                              setState(() {
                                isPlaying = !isPlaying;
                              });

                            }catch(e){
                              ///Print error message in a safe and production friendly way
                              debugPrint(e.toString());
                            }

                          },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 40.0),
                    playerController: playerController,
                    enableSeekGesture: true,
                    waveformType: WaveformType.long,
                    waveformData: playerController.waveformData,
                    playerWaveStyle: const PlayerWaveStyle(
                      fixedWaveColor: Colors.white54,
                      liveWaveColor: Colors.blueAccent,
                      spacing: 6,
                    ),
                  ),
                ),

            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 9.0, bottom: 2),
          child: duration.inMilliseconds>=millisecondsInAnHour?
             ///Display format for when player is at least an hour of duration
             Text(duration.toHHMMSS(), style: const TextStyle(color: Colors.black, fontSize: 9),):

             ///Display format for when player is less than  an hour
             Text(duration.toHHMMSS().substring(3, 8), style: const TextStyle(color: Colors.black, fontSize: 10),),
        )
      ],
    );
  }
}
