import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/meal_mdl.dart';
import 'components/navBar.dart';
import 'comments.dart';
import 'cart.dart';  // Import the CartPage

class FoodListPage extends StatefulWidget {
  final String restaurantName;

  FoodListPage({super.key, required this.restaurantName});

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  // List to store selected items for the cart
  List<Item> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.restaurantName} - Menu"),
      ),
        body: Column(
              children: [
                // Top Section for Restaurant Details
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurantName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Welcome to ${widget.restaurantName}! Explore our delicious menu items.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 8),
                              const Text("123 Restaurant Street, Food City"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Leave a Rating/Comment button
                              ElevatedButton(
                                onPressed: () {
                                  _showRatingDialog(context);
                                },
                                child: const Text("Leave a Rating"),
                              ),
                                 ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentPage(restaurantName: widget.restaurantName),
                                ),
                              );
                            },
                            child: const Text("Comments"),
                          ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

          // Food List Section
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('restaurantName', isEqualTo: widget.restaurantName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No food available"));
                }

                final items = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Item.fromMap(data);
                }).toList();

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    final shortDescription = item.description.length > 50
                        ? '${item.description.substring(0, 47)}...'
                        : item.description;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item.photoUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            shortDescription,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "\$${item.price}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
                                  onPressed: () {
                                    setState(() {
                                      cartItems.add(item);
                                    });
                                    print("Added ${item.name} to cart.");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
                    if (cartItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,  
                          decoration: BoxDecoration(
                            color: Colors.lightGreen, 
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2), 
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),  
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to the CartPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(cartItems: cartItems),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: Colors.transparent, 
                              padding: const EdgeInsets.symmetric(vertical: 16.0),  
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), 
                              ),
                            ),
                            child: const Text(
                              "Go to Cart!",
                              style: TextStyle(
                                fontSize: 18,  
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RatingDialog(restaurantName: widget.restaurantName);
      },
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String restaurantName;

  RatingDialog({super.key, required this.restaurantName});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double selectedRating = 0;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Leave a Rating"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: "Leave a comment",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            String userEmail = "user@example.com"; 

            String comment = commentController.text;
            int rating = selectedRating.toInt();

            if (comment.isEmpty || rating == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please provide a rating and comment")),
              );
              return;
            }

            try {
              await FirebaseFirestore.instance.collection('comments').add({
                'restaurantName': widget.restaurantName,
                'userEmail': userEmail,
                'rating': rating,
                'comment': comment,
                'timestamp': FieldValue.serverTimestamp(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Your rating has been submitted")),
              );

              Navigator.of(context).pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error submitting your rating: $e")),
              );
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
