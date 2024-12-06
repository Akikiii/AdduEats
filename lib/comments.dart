import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  final String restaurantName;

  CommentPage({super.key, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ratings & Comments for $restaurantName"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('restaurantName', isEqualTo: restaurantName)
            .orderBy('timestamp', descending: true)  // Show most recent comments first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No ratings or comments yet."));
          }

          final comments = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'rating': data['rating'],
              'comment': data['comment'],
              'userEmail': data['userEmail'],
              'timestamp': data['timestamp']?.toDate(),  // Convert timestamp to DateTime
            };
          }).toList();

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    children: [
                      // Display rating stars
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < comment['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                            size: 20,
                          );
                        }),
                      ),
                      SizedBox(width: 8),
                      Text("Rating: ${comment['rating']}"),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment['comment']),  // Show the comment
                      SizedBox(height: 8),
                      Text(
                        "By: ${comment['userEmail']}",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Posted on: ${_formatDate(comment['timestamp'])}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper function to format the timestamp
  String _formatDate(DateTime timestamp) {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}";
  }
}
