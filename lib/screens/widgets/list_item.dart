import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../buttons/WaveformButton.dart';
import '../provider/sound_provider.dart';

class Tile extends StatefulWidget {
  const Tile({Key? key, required this.i, required this.record}) : super(key: key);
  final String record;
  final int i;
  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  bool _isPlayed = false;
  int _selectedIndex = -1;
  late String date;
  late AudioPlayer audioPlayer ;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
   date =  _getDateFromFilePatah(filePath: widget.record);
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Row(
        children: <Widget>[
           Expanded(
            flex: 70,
            child: WaveformButton(isPlaying:_isPlaying, onPlay: _onPlay,record:widget.record,  i: _selectedIndex,
            ),
          ),
          Expanded(
            flex: 10,
            child: GestureDetector(
              onTap: (){
                null;
                //to do task
              },
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.black,

              ),
            ),
          ),
          const Expanded(
            flex: 10,
            child: Icon(
              Icons.delete_sweep_outlined,
              color: Colors.black,
            ),
          ),
          const Expanded(
            flex: 10,
            child: Icon(
              Icons.share,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 6,
            child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Image.asset(
                      'assets/images/img_notiblack.png',
                    ),
                  ),
                   const Positioned(
                    top: 0.03,
                    left: 10,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Color(0xff3D79FD),
                      foregroundColor: Colors.white,
                    ), //CircularAvatar
                  ),
                ]
            ),
          ),
        ],
      ),
      subtitle:  Text("${date} "),
    );
  }
  Future<void> _onPlay({required playerController,required String filePath, required int index}) async {


    if (!_isPlaying && !_isPlayed) {
      int result = await audioPlayer.play(filePath ,isLocal: true);
      await playerController.record();

      if (result == 1) {
        setState(() {
          _selectedIndex = index;
          _completedPercentage = 0.0;
          _isPlaying = true;
          _isPlayed = true;
        });
      }else{
        print("Error on resume audio.");

      }

    }else if (_isPlayed && !_isPlaying){

      int result = await audioPlayer.resume();
      await playerController.record();
      if(result == 1){ //resume success
        setState(() {

          _isPlaying = true;
          _isPlayed = true;
        });
      }else {
        print("Error on resume audio.");
      }
    } else{
      int result = await audioPlayer.pause();
      await playerController.pause();

      if(result == 1){ //pause success
        setState(() {

          _isPlaying = false;
          _isPlayed = true;
        });
      }else{
        print("Error on pause audio.");
      }
    }
    audioPlayer.onPlayerCompletion.listen((_) async {
      await playerController.stop();
      setState(() {
        _isPlaying = false;
        _completedPercentage = 0.0;
        _selectedIndex = widget.i;

      });
    });
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration.inMicroseconds;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((duration) {
      setState(() {
        _currentDuration = duration.inMicroseconds;
        _completedPercentage =
            _currentDuration.toDouble() / _totalDuration.toDouble();
      });
    });

  }


  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
    DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;

    return ('$year-$month-$day');
  }
}
