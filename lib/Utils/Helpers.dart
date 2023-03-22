

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Helpers{

  static Color appBlueColor = const Color(0xff3D79FD);

  ///
  Future<Directory> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    final path = Directory('${directory.path}/heartbeat');

    ///if path doesnt exist create it
    await path.exists().then((value){
      if(!value){
        path.create();
      }
    });

    return path;
  }


  ///Get file basename
  String getFileBaseName(File file){
    return file.uri.pathSegments.last.split('.').first;
  }

  ///To delete a recording from the app directory storage/local storage
  deleteRecording(String path){
    File file = File(path);

    if(file.existsSync()){
      file.delete();
    }
  }


  ///Used for confirming before taking irrevertible actions
  confirmActionDialog({required BuildContext context, required String title, required String content, required Function noFunction,
    required Function yesFunction}){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.justify,),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: ()=>noFunction(),
            child: const Text('No', style: TextStyle(color: Colors.red),),
          ),

          TextButton(
            onPressed: ()=>yesFunction(),
            child: const Text('Yes', style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }


}