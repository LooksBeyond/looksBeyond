import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/CategoryList.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String? userEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Looks Beyond Dashboard",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              "User Email: $userEmail",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            Text("Categories"),
            SizedBox(height: 10.0),
            CategoryList()
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
