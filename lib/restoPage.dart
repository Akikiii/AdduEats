import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'components/navBar.dart';
import 'foodList.dart';

void logout(BuildContext context) async {}

class RestoPage extends StatefulWidget {
  const RestoPage({super.key});

  @override
  _RestoPageState createState() => _RestoPageState();
}

class _RestoPageState extends State<RestoPage> {
  final List<Map<String, String>> restaurants = [
    {"name": "Taco Stall", "image": "assets/restaurant.jpg"},
    {"name": "Carenderia", "image": "assets/restaurant.jpg"},
    {"name": "Carenderia 2", "image": "assets/restaurant.jpg"},
    {"name": "JM Shawarma", "image": "assets/restaurant.jpg"},
  ];

  final List<Map<String, String>> ads = [
    {"image": "assets/ads1.jpg"},
    {"image": "assets/ads2.jpg"},
    {"image": "assets/ads3.png"},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Implement search functionality here if needed
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              logout(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard'),
              onTap: () {
                // Handle Dashboard navigation
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Handle Profile navigation
              },
            ),
            ListTile(
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Ad Carousel at the top
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0, // Adjust height for ads
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              enableInfiniteScroll: true,
            ),
            items: ads.map((ad) {
              return GestureDetector(
                onTap: () {
                  // Handle ad click, for example, open the ad URL
                  // You could use a package like url_launcher to open links
                  print("Ad clicked: ${ad['url']}");
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.asset(
                      ad["image"]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Restaurant Carousel
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
              ),
              items: restaurants
                  .where((restaurant) => restaurant["name"]!.toLowerCase().contains(searchQuery))
                  .map((restaurant) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to FoodListPage when a restaurant is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodListPage(restaurantName: restaurant["name"]!),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                            child: Image.asset(
                              restaurant["image"]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            restaurant["name"]!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarComponent(currentIndex: 1),
    );
  }
}
