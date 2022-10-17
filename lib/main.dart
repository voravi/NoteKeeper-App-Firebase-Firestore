import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper_app_firebase_miner2/utils/appRoutes.dart';
import 'package:notekeeper_app_firebase_miner2/utils/routes.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoteKeeper App",
      //home: HomePage(),
      initialRoute: AppRoutes().splashScreen,
      routes: routes,
    );
  }
}