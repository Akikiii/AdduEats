import 'package:cloud_firestore/cloud_firestore.dart'; 

class Item {
  final String name;
  final String description;
  final DateTime dateCreated; 
  final String photoUrl;
  final int price;

  Item({
    required this.name,
    required this.description,
    required this.dateCreated,
    required this.photoUrl,
    required this.price,
  });

  factory Item.fromMap(Map<String, dynamic> data) {
    final timestamp = (data['dateCreated'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
    final dateCreated = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return Item(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      dateCreated: dateCreated,
      photoUrl: data['photoUrl'] ?? '',
      price: data['price'] ?? 0,
    );
  }
 
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateCreated': Timestamp.fromMillisecondsSinceEpoch(dateCreated.millisecondsSinceEpoch), 
      'photoUrl': photoUrl,
      'price': price,
    };
  }
}