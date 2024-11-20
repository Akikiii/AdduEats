import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'logPage_scratch.dart';
import 'package:firebase_auth/firebase_auth.dart';

void logout(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut(); // Clears Google sign-in session
  await FirebaseAuth.instance.signOut(); // Signs out Firebase user
  print("User logged out.");

  // Navigate back to the SignInPage
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInPage()),
  );
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              logout(context); // Use the logout function
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
