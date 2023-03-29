

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/Utils/Helpers.dart';
import 'package:mboathoscope/buttons/headerHalf.dart';



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


///Get locally saved heartbeats
List<PlayerController> getRecordedHeartBeats(){
  return [];
}


class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      resizeToAvoidBottomInset: false, ///Prevent overflows/renderflex error triggered from keyborad ejection/usage
      body: const HeaderHalf(),
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
        selectedItemColor:  Helpers.appBlueColor,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}