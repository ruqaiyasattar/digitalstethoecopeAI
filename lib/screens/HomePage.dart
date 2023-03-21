import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/functions/RecordingList.dart';
import 'package:mboathoscope/functions/headerHalf.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Directory appDirectory;
  // This widget is the root of your application.
  int _selectedIndex = 0;
  List<String> records = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: ListView(
        children: [
          headerHalf(onSaved: _onRecordComplete),
          RecordingList(
            records: records,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: const Color(0xffF3F7FF),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF3F7FF),
            icon: ImageIcon(
              color: Colors.blueAccent,
              AssetImage("assets/images/img_profile.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              color: Colors.blueAccent,
              AssetImage("assets/images/img_explore.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              color: Colors.blueAccent,
              AssetImage("assets/images/img_recordings.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              color: Colors.blueAccent,
              AssetImage("assets/images/img_setting.png"),
            ),
            label: '',
          )
        ],
        selectedItemColor: const Color(0xff3D79FD),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }
}
