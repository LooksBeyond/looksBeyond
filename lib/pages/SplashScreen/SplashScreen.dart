import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looksbeyond/pages/Dashboard/dashboard.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is already logged in, navigate to home page directly
      _navigateToHome();
    } else {
      // User is not logged in, navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: SvgPicture.asset(
              'assets/img/login_logo.svg',
              height: MediaQuery.of(context).size.height > 800 ? 140.0 : 150,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
