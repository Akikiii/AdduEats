import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:campusdiningapp_mobile/model/meal_mdl.dart'; // Import your Item model
import 'package:firebase_auth/firebase_auth.dart'; // Data authentication (For id)

class FirestoreService {
  final FirebaseFirestore db =
      FirebaseFirestore.instance; 

  Future<List<Item>> fetchAllItems() async {
    try {
      final snapshot = await db.collection('items').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return Item.fromMap(doc.data());
        }).toList();
      } else {
        throw Exception("No items found");
      }
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

Future<void> saveSearchHistory(String query) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      String trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) {
        print('Query is blank or only contains spaces. Not saving.');
        return; 
      }
      DocumentSnapshot docSnapshot = await db.collection('searchHistory').doc(user.uid).get();
      List<String> existingSearches = [];

      if (docSnapshot.exists) {
        existingSearches = List<String>.from(docSnapshot['searches'] ?? []);
        if (!existingSearches.contains(trimmedQuery)) {
          existingSearches.add(trimmedQuery);
        }
        print('Fetched search history: $existingSearches');
      } else {
        existingSearches = [trimmedQuery];
      }
      await db.collection('searchHistory').doc(user.uid).set({
        'userId': user.uid,
        'searches': existingSearches,
      });
    } catch (e) {
      print("Error in adding search history: $e");
    }
  }
}
  Future<List<String>> fetchSearchHistory() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var snapshot =
          await db.collection('searchHistory').doc(currentUser.uid).get();
      if (snapshot.exists) {
        return List<String>.from(snapshot.data()?['searches'] ?? []);
      }
    }
    return [];
  }
}

  

