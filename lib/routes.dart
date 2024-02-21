import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/AdditonalInfo/AdditionalInfoScreen.dart';
import 'package:looksbeyond/pages/Booking/bookingDetails.dart';
import 'package:looksbeyond/pages/BrandDisplay/BrandDisplayScreen.dart';
import 'package:looksbeyond/pages/CreateBooking/CreateBooking.dart';
import 'package:looksbeyond/pages/Dashboard/dashboard.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/ServicesList.dart';
import 'package:looksbeyond/pages/EmployeeInfo/EmployeeInfoScreen.dart';
import 'package:looksbeyond/pages/Feedback/feedbackScreen.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';
import 'package:looksbeyond/pages/Payment/PaymentScreen.dart';
import 'package:looksbeyond/pages/Search/searchScreen.dart';
import 'package:looksbeyond/pages/ServiceEmployees/ServiceEmployees.dart';
import 'package:looksbeyond/pages/SplashScreen/SplashScreen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  LoginPage.pageName: (context) => const LoginPage(),
  BottomNavBarScreen.pageName: (context) => const BottomNavBarScreen(),
  BookingDetails.pageName: (context) => BookingDetails(),
  FeedbackPage.pageName: (context) => const FeedbackPage(),
  SearchScreen.pageName: (context) => SearchScreen(),
  AdditionalInfoScreen.pageName: (context) => const AdditionalInfoScreen(),
  ServicesList.pageName: (context) => const ServicesList(),
  ServiceEmployees.pageName: (context) => const ServiceEmployees(),
  CreateBooking.pageName: (context) => const CreateBooking(),
  PaymentScreen.pageName: (context) => const PaymentScreen(),
  EmployeeInfoScreen.pageName: (context) => const EmployeeInfoScreen(),
  BrandDisplayScreen.pageName: (context) => BrandDisplayScreen(),
};
