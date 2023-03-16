import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mboathoscope/buttons/RecordingList.dart';
import 'package:mboathoscope/screens/provider/record_provider.dart';
import 'package:mboathoscope/screens/provider/sound_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../buttons/headerHalf.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
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
  // This widget is the root of your application.
  int _selectedIndex = 0;
  late final SoundProvider provider;
  List<dynamic> records = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
       provider =  Provider.of<SoundProvider>(context, listen: false);
       await provider.getRecords();
    });
  }

  @override
  void dispose() {
    provider.appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final soundProvider = Provider.of<SoundProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: SingleChildScrollView(
        child: Column(
          children:  [
            headerHalf(onRecord:onRecordComplete),
            RecordingList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: const Color(0xffF3F7FF),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor:  Color(0xffF3F7FF),
            icon: ImageIcon(
              AssetImage("assets/images/img_profile.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/img_explore.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/img_recordings.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/img_setting.png"),
            ),
            label: '',
          )
        ],
        selectedItemColor:  const Color(0xff3D79FD),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
  onRecordComplete() async {
    try{

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: (provider.isSaved) ? const Text('Please First Record.'):Text('Saved Successfully.'),
      ));
      // (provider.isSaved) ? null :
      await provider.onRecordComplete();

    }catch(e){
      print('failed to record');
    }
  }
}