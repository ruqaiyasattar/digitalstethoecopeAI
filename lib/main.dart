import 'package:flutter/material.dart';
import 'package:mboathoscope/screens/HomePage.dart';
import 'package:mboathoscope/screens/RolePage.dart';
import 'package:mboathoscope/screens/StartPage.dart';
import 'Utils/AppDirectorySingleton.dart';
import 'package:provider/provider.dart' as provider;





void main() async{

  ///
  WidgetsFlutterBinding.ensureInitialized();
  await AppDirectorySingleton().getAppDirectory();
  await AppDirectorySingleton().fetchRecordings();

  runApp(
      provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<AppDirectorySingleton>(create: (_) => AppDirectorySingleton()),
        ],
        child: MaterialApp(
          // title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const StartPage(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '': (context) => const StartPage(),
            '/rolepage': (context) => const RolePage(),
            '/homepage': (context) => const HomePage(),
          },
        ),
      )
  );
}



