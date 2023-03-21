import 'package:flutter/material.dart';
import 'package:mboathoscope/CustomButton.dart';

class RolePage extends StatelessWidget {
  const RolePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: size.height / 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 26, right: 26, top: 87),
          //   child:
          Image.asset(
            'assets/images/img_role.png',
            height: 280,
          ),
          //),
          // const Padding(
          //   padding: EdgeInsets.only(left: 23, right: 23),
          //   child:
          Text(
            'Please select what your role is',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            //),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 55, right: 38, left: 38),
          //   child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CustomButton(
                txt: 'Transmitter',
              ),
              // SizedBox(
              //   width: 60,
              // ),
              CustomButton(
                txt: 'Receiver',
              )
            ],
            //),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 300, top: 30),
          //   child:
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
            style: ButtonStyle(
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(width: 2, color: Colors.transparent),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                // minimumSize: MaterialStateProperty.all<Size>(
                //     Size(size.width / 5.0, size.height / 20.0)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xffC5D7FE))),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 28.0, right: 28.0, top: 10.0, bottom: 10.0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Next ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.blueAccent)),
                    WidgetSpan(
                      child: Icon(Icons.arrow_forward_ios, size: 24),
                    ),
                  ],
                ),
                //),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
