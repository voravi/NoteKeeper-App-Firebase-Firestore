import 'package:flutter/cupertino.dart';
import 'package:notekeeper_app_firebase_miner2/splash_screen.dart';


import '../screens/home_screen/page/home_screen.dart';
import 'appRoutes.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes().homePage: (context) => HomePage(),
  AppRoutes().splashScreen: (context) => IntroScreen(),

};
