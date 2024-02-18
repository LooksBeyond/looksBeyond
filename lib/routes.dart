import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/Booking/bookingDetails.dart';
import 'package:looksbeyond/pages/Dashboard/dashboard.dart';
import 'package:looksbeyond/pages/Feedback/feedbackScreen.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';
import 'package:looksbeyond/pages/Search/searchScreen.dart';
import 'package:looksbeyond/pages/SplashScreen/SplashScreen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  LoginPage.pageName: (context) => const LoginPage(),
  BottomNavBarScreen.pageName: (context) => const BottomNavBarScreen(),
  BookingDetails.pageName: (context) => const BookingDetails(),
  FeedbackPage.pageName: (context) => const FeedbackPage(),
  SearchScreen.pageName: (context) => SearchScreen(),
};
