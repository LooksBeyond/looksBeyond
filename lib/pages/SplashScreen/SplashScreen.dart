import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is already logged in, navigate to home page directly
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _navigateToHome();
      });
    } else {
      // User is not logged in, navigate to login screen
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _navigateToLogin();
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
        body: Container(
          child: Center(
            child: SvgPicture.asset(
              'assets/img/login_logo.svg',
              height: MediaQuery.of(context).size.height > 800 ? 140.0 : 150,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );

  }
}
