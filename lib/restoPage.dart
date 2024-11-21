import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'logPage_scratch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campusdiningapp_mobile/services/dtb_services.dart'; 
import 'package:campusdiningapp_mobile/model/meal_mdl.dart'; 
import 'package:campusdiningapp_mobile/components/displayCard.dart';
void logout(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut(); 

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInPage()),
  );
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Item> items = [];
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      var fetchedItems = await FirestoreService().fetchAllItems();
      setState(() {
        items = fetchedItems;  
        isLoading = false;  
      });
    } catch (e) {
      setState(() {
        isLoading = false;  
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch data: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items List"),
          actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              logout(context); 
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return DisplayCard(item: item);  
              },
            ),
    );
  }
}