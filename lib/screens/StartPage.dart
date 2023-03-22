

import 'package:flutter/material.dart';
import 'package:mboathoscope/buttons/CustomButton.dart';
import '../Utils/Helpers.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26,right: 26, top: 87),
            child: Image.asset(
                'assets/images/img.png',
              height: 280,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23, right: 23),
            child: Text(
                'mboathoscope',
                 style: TextStyle(
                 color: Helpers.appBlueColor,
                 fontWeight: FontWeight.bold,
                 fontSize: 45,
              ),
            ),
          ),
          const SizedBox(
            height: 39,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context,'/rolepage');
            },
            child: const Padding(
              padding: EdgeInsets.only(bottom: 199),
              child: CustomButton(
                txt: 'Get Started',
              ),
            ),
          )
        ],
      ),
    );
  }
}