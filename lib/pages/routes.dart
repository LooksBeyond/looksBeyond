import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/Dashboard/dashboard.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';
import 'package:looksbeyond/pages/SplashScreen/SplashScreen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/login': (context) => const LoginPage(),
  '/dashboard': (context) => const Dashboard(),
};
