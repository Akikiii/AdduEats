import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:campusdiningapp_mobile/model/meal_mdl.dart'; // Import your Item model

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance; // Initialize Firestore

  // Method to fetch all items
  Future<List<Item>> fetchAllItems() async {
    try {
      // Get a snapshot of all documents in the 'items' collection
      final snapshot = await db.collection('items').get();

      // Check if data exists and parse the documents into Item objects
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return Item.fromMap(doc.data()); // Map Firestore document data to Item model
        }).toList();
      } else {
        throw Exception("No items found");
      }
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }
}



//! Real time database
// import 'package:firebase_database/firebase_database.dart';
// import 'package:exam_fetch/model/meal_mdl.dart';

// DatabaseReference ref = FirebaseDatabase.instance.ref();

// Future<List<Item>> fetchAllItems() async {
//   try {
//     // Get a snapshot of all items
//     final snapshot = await ref.child('items').get();

//     // Check if data exists
//     if (snapshot.exists) {
//       // Parse the data and return as a list of Item objects
//       Map<String, dynamic> data = Map.from(snapshot.value as Map);
//       return data.entries.map((entry) {
//         return Item.fromMap(entry.value);
//       }).toList();
//     } else {
//       throw Exception("No data available");
//     }
//   } catch (e) {
//     throw Exception("Failed to fetch data: $e");
//   }
// }