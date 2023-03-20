import 'package:flutter/material.dart';
import 'package:mboathoscope/CustomButton.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 8.0),
              child: Image.asset(
                'assets/images/img.png',
                height: MediaQuery.of(context).size.height / 4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 8.0),
            child: const Text(
              'mboathoscope',
              style: TextStyle(
                color: Color(0xff3D79FD),
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/rolepage');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 8.0),
              child: const CustomButton(
                txt: 'Get Started',
              ),
            ),
          )
        ],
      ),
    );
  }
}
