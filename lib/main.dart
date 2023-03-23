import 'package:flutter/material.dart';
import 'package:mboathoscope/screens/HomePage.dart';
import 'package:mboathoscope/screens/RolePage.dart';
import 'package:mboathoscope/screens/StartPage.dart';
import 'package:mboathoscope/screens/stethoecopedonation.dart';

void main() {
  runApp(
    MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '': (context) => const StartPage(),
        '/rolepage': (context) => const RolePage(),
        '/homepage': (context) => const HomePage(),
        '/donationpage': (context) => const DonationPage(),
      },
    ),
  );
}
