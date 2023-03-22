



import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/Utils/Helpers.dart';


class AppDirectorySingleton with ChangeNotifier{
  static final AppDirectorySingleton _singleton = AppDirectorySingleton._internal();
  late Directory appDirectory; ///Directory for saving recordings
  static String heartBeatParentPath = 'heartbeat'; ///Direct Directory name for where recordings are saved
  late Map<String, PlayerController> heartbeatAndPathMap; ///Key and Value pair of Recordings and its corresponding path


  factory AppDirectorySingleton() {
    return _singleton;
  }

  AppDirectorySingleton._internal();


  ///Gets app Directory
  getAppDirectory()async{
    await Helpers().localPath.then((value) => appDirectory=value);
  }


  ///Fetch recordings saved in application Directory
  fetchRecordings()async{
    Map<String, PlayerController> heartbeatsAndPaths = {};

    for(FileSystemEntity fileSystem in appDirectory.listSync()){

      ///
      File tempHeartBeatFile = File(fileSystem.path);

      if(tempHeartBeatFile.path.contains(heartBeatParentPath)){
        PlayerController tempHeartBeatPlayerController = PlayerController();

        await tempHeartBeatPlayerController.preparePlayer(
          path: tempHeartBeatFile.path,
          shouldExtractWaveform: true,
          volume: 1.0,
        );

        heartbeatsAndPaths[tempHeartBeatFile.path] = tempHeartBeatPlayerController;
      }
    }

    ///adds recording and its path to the globally declared recoring and its path
    heartbeatAndPathMap = heartbeatsAndPaths;
  }


  ///Adds new recodings(Player and its path) to the global singleton
  addToHeartBeatAndPathMap(String path, PlayerController playerController){
    ///add to app directory storage
    ///Saving to local diretory happens automatically after every recording
    ///so there is no need to add to app Directory

    ///add to app context
    heartbeatAndPathMap[path] = playerController;

    notifyListeners();
  }


  ///Removes recording from application Directory memory and global singleton value
  deleteFromHeartBeatAndPathMap(String path){
    ///remove from app directory storage
    Helpers().deleteRecording(path);

    ///remove from app context
    if(heartbeatAndPathMap.containsKey(path)){
      heartbeatAndPathMap.remove(path);
    }

    ///Use to inform all consumers of changenotifier of
    ///updates on recording map(i.e. heartbeatAndPathMap)
    notifyListeners();
  }


  ///Renames a recording
  ///newPath:basename of file
  ///oldFile: Full Path of file
  ///It has a bug: After a successful rename, the audioplayer, loses it wave data
  ///Plan to debug after contribution to find out why
  renameHeartBeatAndPathMap({required String newPath, required String oldPath})async{
    ///rename from app directory storage
    File oldPathFile = File(oldPath);
    String newfileFullPath = '${oldPathFile.parent.path}/$newPath';
    await oldPathFile.rename(newfileFullPath);

    final PlayerController tempPlayerController;


    ///rename from app context
    if(heartbeatAndPathMap.containsKey(oldPath)){

      ///creates a temp to store player before delete of oldPath key and value
      tempPlayerController = heartbeatAndPathMap[oldPath]!;

      var removedPath = heartbeatAndPathMap.remove(oldPath);

      if(removedPath!=null && !heartbeatAndPathMap.containsKey(oldPath)){

        heartbeatAndPathMap[newfileFullPath] = tempPlayerController;
      }
    }

    ///Use to inform all consumers of changenotifier of
    ///updates on recording map(i.e. heartbeatAndPathMap)
    notifyListeners();
  }

}