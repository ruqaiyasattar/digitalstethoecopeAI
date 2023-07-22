import 'package:flutter/material.dart';
import 'package:mboathoscope/screens/HomePage.dart';
import 'package:mboathoscope/screens/RolePage.dart';
import 'package:mboathoscope/screens/StartPage.dart';


void main() {

  runApp(const EntryRoot());
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          // title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.blue
          ),
          home: const StartPage(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '': (context) => const StartPage(),
            '/rolepage': (context) => const RolePage(),
            '/homepage': (context) => const HomePage(),
          },
    );
  }
}



