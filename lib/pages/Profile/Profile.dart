import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/models/logged_in_user.dart';
import 'package:looksbeyond/pages/Login/loginPage.dart';
import 'package:looksbeyond/provider/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AuthenticationProvider authenticationProvider;
  late LoggedInUser loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    loggedInUser= authenticationProvider.loggedInUser!;
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = loggedInUser.email;
    String? userName = loggedInUser.name;
    String? userPhone = loggedInUser.phoneNumber;
    int? userAge = loggedInUser.age;
    String? address = loggedInUser.address;
    String userImg = loggedInUser.profileImage;


    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userImg),
            ),
            SizedBox(height: 20),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text( userEmail.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(userPhone),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text(address),
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_sharp),
              title: Text(userAge.toString()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authenticationProvider.signOut(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
