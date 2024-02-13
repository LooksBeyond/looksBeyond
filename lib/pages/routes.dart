import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/Dashboard/dashboard.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginPage(), // Default route
  '/home': (context) => Dashboard(),
};
