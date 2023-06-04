import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/buttons/WaveformButton.dart';
import 'package:mboathoscope/buttons/textButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../services/permission_management.dart';
import '../services/storage_management.dart';
import '../services/toast_services.dart';

class Homebody extends StatefulWidget {
  @override
  State<Homebody> createState() => _HomeState();
}

class _HomeState extends State<Homebody> {
  late final RecorderController recorderController;

  String? path;
  List<String> records = [];
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    final _isPermitted = (await PermissionManagement.recordingPermission()) &&
        (await PermissionManagement.storagePermission());

    if (!_isPermitted) return;
    // if(!(await _record.hasPermission())) return;
    final _voiceDirPath = await StorageManagement.getAudioDir;

    appDirectory = await getApplicationDocumentsDirectory();
    path = StorageManagement.createRecordAudioPath(
        dirPath: appDirectory.path, fileName: 'audio_message');
    // path = "${appDirectory.path}/recording.m4a";

    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  //
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      musicFile = result.files.single.path;
      setState(() {});
    } else {
      debugPrint("File not picked");
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          /////..............
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/img_round.png',
                                    height: 80,
                                    width: 80,
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
                          //.........
                          Expanded(
                            flex: 4,
                            child: InkWell(
                                onTap: _startOrStopRecording,
                                child: isRecording
                                    ? RippleAnimation(
                                        repeat: true,
                                        color: const Color(0xff3D79FD),
                                        minRadius: 70,
                                        ripplesCount: 6,
                                        child: const CircleAvatar(
                                          maxRadius: 60.0,
                                          backgroundColor: Colors.blueAccent,
                                          child: Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                            size: 60.0,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        maxRadius: 60.0,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          'assets/images/img_record.png',
                                          height: 150,
                                          width: 150,
                                        ),
                                        // Icon(Icons.mic,
                                        //     color: Colors.white,
                                        //     size: 60.0,
                                        //   )
                                      )),
                          ),
                          //.......................
                          Expanded(
                            flex: 3,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 9.0, right: 17.0),
                                child: TextButton(
                                  style: flatButtonStyle,
                                  onPressed: () {},
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff3D79FD),
                                    ),
                                  ),
                                )),
                          ),
                          //.....................
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Press and hold the button to transmit the sound',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 400),
                    const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Please ensure that you are wearing noise cancelling headphones',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Recordings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (records.isEmpty) const Text("No recordings"),
                    if (isRecordingCompleted)
                      Column(
                            children: [
                              SingleChildScrollView(
                                child: SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: records.length,
                                    itemBuilder: (context, index) => WaveBubble(
                                      path: records[index],
                                      isSender: true,
                                      appDirectory: appDirectory,
                                      recordingNumber: index + 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
    );
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();
        showToast('Recording stopped');

        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          records.add(path);
          print("sssssssssssssssss$records[0]");
          print("ppppppppppppppp$records");
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController.record(path: path!);
        showToast('Recording Started');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

// void _refreshWave() {
//   if (isRecording) recorderController.refresh();
// }
}
