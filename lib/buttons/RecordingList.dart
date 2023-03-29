
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mboathoscope/Utils/AppDirectorySingleton.dart';
import 'package:mboathoscope/Utils/Helpers.dart';
import 'package:mboathoscope/buttons/WaveformButton.dart';
import 'package:provider/provider.dart';





class RecordingList extends StatefulWidget {
  const RecordingList({super.key});

  @override

  State<RecordingList> createState() => _RecordingListState();
}


late TextEditingController _textEditingController;




class _RecordingListState extends State<RecordingList> {

  ///
  late Map<String, PlayerController> _heartbeatAndPathMap;


  ///For deletion of a recording
  ///Feature has a bug where upon deletion, the UI update causes an undeleted right behind the file deleted
  ///to pick its player, so you will notice that the file before or after takes the deleted players duration,
  ///when this happens, the affected player can only play ones and since it is carrying a deleted player
  ///I hope this fixed this after the contribution stage
  deleteRecordingLocal(AppDirectorySingleton appDirectorySingleton, String path) async {

    ///Confirm Deletion
    Helpers().confirmActionDialog(context:context, title: 'Delete BP',
        content: "Do you want to delete BP?",
        yesFunction: (){
          ///
          appDirectorySingleton.deleteFromHeartBeatAndPathMap(path);
          Navigator.pop(context);
        },
        noFunction: (){
          Navigator.pop(context);
        }

    );
  }


  ///For the rename of an existing Recording
  renameRecordingLocal({required AppDirectorySingleton appDirectorySingleton, required String oldPath}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(25.0)), //this right here
            child: SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Rename BP Recording"),

                    TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Helpers().getFileBaseName(File(oldPath)))
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 120.0,
                          child: TextButton(
                            onPressed: ()=>Navigator.pop(context),
                            //color: const Color(0xFF1BC0C5),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 120.0,
                          child: TextButton(
                            onPressed: (){
                              ///Executes the rename function
                              appDirectorySingleton.renameHeartBeatAndPathMap(
                                  newPath:_textEditingController.text, oldPath:oldPath);

                              ///To dismiss dialog
                              Navigator.pop(context);

                              ///To allow for everying file to carry their old path as hint
                              ///and make this field empty on default, if this isn't done it
                              ///will carry the last renamed files name as initial entry/path
                              _textEditingController.clear();
                            },
                            child: Text("Save",
                              style: TextStyle(color: Helpers.appBlueColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }
      );
  }


  @override
  void initState() {
    ///Initialises the input field for renaming, without there will be an error
    ///and if it initialized in the body where field is being used, it will clear
    ///upon clicking done/exiting the keyboard, so this is the best place to
    ///initialise
    _textEditingController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  ///Widget for the list of recordings
  Widget recordingListBody(PlayerController heartBeatPlayer, String heartBeathFilePath, AppDirectorySingleton appDirectorySingleton){
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 45,
            child: WaveformButton(playerController: heartBeatPlayer,),
          ),
          Expanded(
            flex: 10,
            child: GestureDetector(
              onTap: (){
                Fluttertoast.showToast(
                    msg: 'This feature is not yet available',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                ///It has a bug: After a successful rename, the audioplayer,
                ///loses it wave data after one single play
                ///Executes the renaming of existing recording
                // renameRecordingLocal(
                //     appDirectorySingleton:appDirectorySingleton,
                //     oldPath: heartBeathFilePath
                // );
              },
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.black,

              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: IconButton(
              onPressed: ()async{
                Fluttertoast.showToast(
                    msg: 'This feature is not yet available',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                ///Feature has a bug where upon deletion, the UI update causes an undeleted right behind the file deleted
                ///to pick its player, so you will notice that the file before or after takes the deleted players duration,
                ///when this happens, the affected player can only play ones and since it is carrying a deleted player
                ///I hope this fixed this after the contribution stage
                // deleteRecordingLocal(appDirectorySingleton, heartBeathFilePath);
              },
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.black),
            ),
          ),
          // const Expanded(
          //   flex: 10,
          //   child: Icon(
          //     Icons.share,
          //     color: Colors.black,
          //   ),
          // ),

        ],
      ),
      subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          ///Get the name of the file from the full path and display
          child: Text(Helpers().getFileBaseName(File(heartBeathFilePath)), style: const TextStyle(fontSize: 11))),
    );
  }


  @override
  Widget build(BuildContext context) {

    ///Consumer widget to allow for list update upon addition and deletion of a recording
    ///It executes this very quietly without setState
    return Consumer<AppDirectorySingleton>(builder: (BuildContext context, value, Widget? child){

      ///Initialisation of the heartbeat and its corresponding path using the consumer(Notifier)
      ///reference object corresponding to the recording and its path fetched ones from memory
      ///and updates during the global usage across the app
      _heartbeatAndPathMap = value.heartbeatAndPathMap;

      return SizedBox(
        height: 240,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _heartbeatAndPathMap.length, ///TODO: Fetch local storage
          itemBuilder: (context, index) {


            // List<PlayerController>? heartbeatsPlayers = _heartbeatAndPathMap.values.toList();
            // List<String>? heartbeatFilePaths = _heartbeatAndPathMap.keys.toList();

            ///Key: this is used to fetch its coressponding recordings
            String heartBeathFilePath = _heartbeatAndPathMap.keys.elementAt(index);
            ///Value: this is used to fetch the Player value corressponding to a path
            PlayerController heartBeatPlayer = _heartbeatAndPathMap[heartBeathFilePath]!;

            ///Returns recording list widget
            return recordingListBody(heartBeatPlayer, heartBeathFilePath, value);

          },
        ),
      );


    });
  }
}




/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}