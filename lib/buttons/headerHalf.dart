import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mboathoscope/Utils/AppDirectorySingleton.dart';
import 'package:mboathoscope/Utils/Helpers.dart';
import 'package:mboathoscope/buttons/RecordingList.dart';
// import 'package:mboathoscope/buttons/ActionButton.dart';
import '../Utils/PermissionsHelper.dart';




class HeaderHalf extends StatefulWidget {
  const HeaderHalf({Key? key}) : super(key: key);

  @override
  State<HeaderHalf> createState() => _HeaderHalfState();
}

class _HeaderHalfState extends State<HeaderHalf> {

  late final RecorderController recorderController;
  bool isRecordingCompleted = false; ///for time to determine whether to save or delete
  bool isRecording = false; ///for time to determine whether to show microphone or not
  late String path;
  static Directory appDirectory = AppDirectorySingleton().appDirectory;
  String heartBeatFileFolderPath = AppDirectorySingleton.heartBeatParentPath;
  late TextEditingController _textEditingController;


  ///Initializes Recorder
  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }


  ///Starts and Stops Recorder
  _startOrStopRecording() async {
    ///
    checkForMicrophonePermission();

    try{
      if(recorderController.isRecording){

        recorderController.reset();

        ///Stops recording and returns path,
        ///saves file automatically here
        recorderController.stop(false).then((value)async{

          PlayerController tempHeartBeatPlayerController = PlayerController();

          await tempHeartBeatPlayerController.preparePlayer(
            path: path,
            shouldExtractWaveform: true,
            volume: 1.0,
          );

          ///Add to local recording Map/Iterable for Global context
          ///usage without having to read from Local Storage
          AppDirectorySingleton().addToHeartBeatAndPathMap(path, tempHeartBeatPlayerController);

        });

        ///Remove because rename and delete functions have a bug
        ///This allows UI to switch to allow user to either save or delete, also allow for rename
        setState(() {
          isRecording = !isRecording;
          // isRecordingCompleted = true;
        });

      }else{

        ///States paths for recording to be saved
        path = "${appDirectory.path}/$heartBeatFileFolderPath${DateTime.now().millisecondsSinceEpoch}.mpeg4";

        await recorderController.record(path: path);

        /// refresh state for changes on page to reflect
        setState(() {
          isRecording = !isRecording;
        });

      }

    }catch(error){

      debugPrint(error.toString());

    }finally {

    }

  }


  ///
  saveRecording(){
    ///Rename if user change default recording name
    if(_textEditingController.text.isNotEmpty){

      ///Rename file
      ///It has a bug: After a successful rename, the audioplayer, loses it wave data,
      ///so this function will always be false since I have set input field to read only
      AppDirectorySingleton().renameHeartBeatAndPathMap(newPath: _textEditingController.text, oldPath: path);


      ///Clears textfiled after saving file so default file name takes over for new file name
      _textEditingController.clear();
    }

    ///Remove because rename and delete functions have a bug
    // setState(() {
    //   ///set isRecordingCompleted to false to allow UI to move to default ready to record,
    //   ///else it will stay on save or delete, without allowing new
    //   ///audio to be recorded
    //   isRecordingCompleted = !isRecordingCompleted;
    // });


    ///Toast message of successful addition of new recording
    Fluttertoast.showToast(
        msg: 'New BP Record Added',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    
  }


  ///
  deleteRecordingLocal(String path){
    ///
    AppDirectorySingleton().deleteFromHeartBeatAndPathMap(path);

    ///Remove because rename and delete functions have a bug
    ///set isRecordingCompleted to false to allow UI to move to default ready to record,
    ///else it will stay on save or delete, without allowing new
    ///audio to be recorded
    // setState(() {
    //   isRecordingCompleted = !isRecordingCompleted;
    // });
  }


  ///Check for microphone permission
  checkForMicrophonePermission()async{
    final hasPermission = await recorderController.checkPermission();
    if(!hasPermission){
      await PermissionsHelper().checkAndRequestForAudioRecordingPermission();
    }
  }


  @override
  void initState() {

    _initialiseController();

    ///Field for renaming recording
    _textEditingController = TextEditingController();

    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorderController.dispose();
  }



  ///
  Widget recordBody(){

    ///set to false when on init and when recording is completed and saved
    // if(isRecordingCompleted){
    //
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 25),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Expanded(
    //             flex: 20,
    //             child: ActionButton(onPress: ()=> deleteRecordingLocal(path), txt: 'delete', color: Colors.red,),
    //         ),
    //         Expanded(
    //           flex: 70,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 IconButton(
    //                   icon: const Icon(Icons.multitrack_audio_outlined),
    //                   iconSize: 70,
    //                   color:  Helpers.appBlueColor,
    //                   onPressed: (){
    //                     ///Start or Stop Recording
    //                     _startOrStopRecording();
    //                   },
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(left: 30.0),
    //                   child: TextField(
    //                     controller: _textEditingController,
    //                     readOnly: true, ///will set to false when I fix rename bug for now its using default file name
    //                     // autofocus: true, ///will activate when I fix rename bug
    //                     decoration: InputDecoration(
    //                         border: InputBorder.none,
    //                         hintText: Helpers().getFileBaseName(File(path)), hintStyle: const TextStyle(fontSize: 12)),
    //                   ),
    //                 )
    //               ],
    //             )
    //         ),
    //
    //         Expanded(
    //           flex: 20,
    //             child: ActionButton(onPress: (){
    //               ///Save Recording, Recording saves automatically but this allows for rename of file
    //               saveRecording();
    //             }, txt: 'save', color: Helpers.appBlueColor)),
    //       ],
    //     ),
    //   );
    // }

    if(isRecording){ ///recorderController.isRecording: could have used this but issuing stoprecorder doesn't change it state, will investigate why it doesn't refresh
      return InkWell(
        onTap: (){
          ///For Start or Stop Recording
          _startOrStopRecording();
        },
        child: SafeArea(
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: AudioWaveforms(
                enableGesture: false,
                size: Size(MediaQuery.of(context).size.width / 2, 50),
                recorderController: recorderController,
                waveStyle: const WaveStyle(waveColor: Colors.white, extendWaveform: true, showMiddleLine: false,
                 durationStyle: TextStyle(color: Colors.black), showDurationLabel: true,
                    durationLinesColor: Colors.transparent),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Helpers.appBlueColor,),
                padding: const EdgeInsets.only(left: 18),
                margin: const EdgeInsets.symmetric(horizontal: 15),
              )

          ),
        ),
      );
    }else{

      ///Applies when recording is completed and saved or start of the page
      return IconButton(
        icon: const Icon(Icons.mic),
        iconSize: 100,
        color:  Helpers.appBlueColor,
        onPressed: (){
          ///Start or Stop Recording
          _startOrStopRecording();
        },
      );

    }

  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0,left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/img_head.png',
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                width: 200,
              ),

              Expanded(
                flex: 1,
                //padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Stack(
                  children:[
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/img_round.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/img_heart.png',
                              height: 25,
                              width: 25,
                            ),
                            const Text(
                              'heart',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: 20.0,
            bottom: 20.0,
          ),
          child: recordBody(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            'Press and hold the microphone button above to transmit the sound',
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(fontSize: 16,),
          ),
        ),
        Padding(
          padding:  const EdgeInsets.only(top: 10.0, bottom: 35.0, left: 35.0, right: 35.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info_outline, size: 20, color: Colors.green,),
              Expanded(
                child: Text(
                  'Please ensure that you are wearing noise cancelling headphones',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 13, color: Colors.green
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 25.0),
                  child: Column(
                    children: const[
                      Text(
                        'Recordings',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ///Think of making this class also a Consumer of the AppDirectorySingleton() Changenotifier else
            ///unless you refresh you won't see newly added files because RecordingList() would not have been
            ///initialized to allow update of recording upon add
            // AppDirectorySingleton().heartbeatAndPathMap.isEmpty?
            // ///UI for when there are no recordings saved to let the user know what
            // ///they are to do in order to get a recording in the list
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            //   child: Text('You have no recording, To begin recording, click on the microphone icon above',
            //     maxLines: 3,),
            // ):
            // ///UI for when there is at least one recording
            const RecordingList(),
          ],
        ),
      ],
    );
  }

}




