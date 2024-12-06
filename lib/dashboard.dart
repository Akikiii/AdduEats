// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:campusdiningapp_mobile/services/dtb_services.dart'; // FirestoreService
// import 'package:campusdiningapp_mobile/model/meal_mdl.dart'; // Item model
// import 'package:campusdiningapp_mobile/components/displayCard.dart'; // DisplayCard widget
// import 'components/navBar.dart'; // Import your navigation bar component
// import 'logPage_scratch.dart';
// import 'package:campusdiningapp_mobile/profilePage.dart';

// import 'components/rangeSlider.dart'; //* Filter: Range slider
// import 'components/filterChip.dart'; //* Search History

// void logout(BuildContext context) async {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   await googleSignIn.signOut();
//   await FirebaseAuth.instance.signOut();

//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(builder: (context) => SignInPage()),
//   );
// }

// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   List<Item> items = [];
//   bool isLoading = true;
//   String searchQuery = '';
//   List<String> searchHistory = [];
//   RangeValues _currentRangeValues = const RangeValues(20, 300);
//   bool showSearchHistory = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchItems();
//     _loadSearchHistory(); // Load search history when the page is loaded
//   }

//   Future<void> _fetchItems() async {
//     try {
//       var fetchedItems = await FirestoreService().fetchAllItems();
//       setState(() {
//         items = fetchedItems;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Failed to fetch data: $e"),
//       ));
//     }
//   }

//   Future<void> _loadSearchHistory() async {
//     List<String> history = await FirestoreService().fetchSearchHistory();
//     setState(() {
//       searchHistory = history;
//     });
//   }

//   void _onSearchSubmitted(String query) async {
//     if (query.isNotEmpty) {
//       setState(() {
//         searchQuery = query.toLowerCase();
//       });

//       // Save search history to Firestore and update local searchHistory
//       await FirestoreService().saveSearchHistory(query);
//       await _loadSearchHistory(); // Make sure history is refreshed after save
//     } else {
//       setState(() {
//         searchQuery = '';
//       });
//     }
//   }

//   void _onSearchTapped() {
//     setState(() {
//       showSearchHistory = searchQuery.isEmpty; // Only show history if query is empty
//     });
//   }

//   void _onTapOutside() {
//     if (showSearchHistory) {
//       setState(() {
//         showSearchHistory = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Item> filteredItems = items.where((item) {
//       bool matchesName = item.name.toLowerCase().contains(searchQuery);
//       bool withinPriceRange = item.price >= _currentRangeValues.start &&
//           item.price <= _currentRangeValues.end;

//       return matchesName && withinPriceRange;
//     }).toList();

//     return GestureDetector(
//       onTap: _onTapOutside, // Dismiss dropdown when tapping outside
//       child: Scaffold(
//         appBar: AppBar(
//           title: GestureDetector(
//             onTap: _onSearchTapped, // Toggle history on tap
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: 'Search',
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(color: Colors.white70),
//                   ),
//                   style: TextStyle(color: Colors.white),
//                   onSubmitted: _onSearchSubmitted,
//                   onTap: _onSearchTapped, // Show search history when tapped
//                 ),
//               ],
//             ),
//           ),
//           backgroundColor: Colors.teal,
//           actions: [
//             PopupMenuButton<int>(
//               icon: const Icon(Icons.filter_list),
//               itemBuilder: (BuildContext context) => [
//                 PopupMenuItem<int>(child: Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Sort by price:'),
//                       PriceRangeSlider(
//                         initialRangeValues: _currentRangeValues,
//                         onRangeChanged: (RangeValues newRange) {
//                           setState(() {
//                             _currentRangeValues = newRange;
//                           });
//                         },
//                       ),
//                       const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Sort by name: '),
//                           SizedBox(height: 5),
//                           //FilterChipExample(choices: ['A-Z', 'Z-A']),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                       const Column(
//                         children: [Text("Store:")],
//                       )
//                     ],
//                   ),
//                 ))
//               ],
//             ),
//           ],
//         ),
//         drawer: Drawer(
//           child: ListView(
//             children: [
//               const DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Colors.teal,
//                 ),
//                 child: Text(
//                   'Menu',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.home),
//                 title: const Text('Dashboard'),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.account_circle),
//                 title: const Text('Profile'),
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProfilePage()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.logout),
//                 title: const Text('Logout'),
//                 onTap: () => logout(context),
//               ),
//             ],
//           ),
//         ),
//         body: Stack(
//           children: [
//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: filteredItems.length,
//                     itemBuilder: (context, index) {
//                       var item = filteredItems[index];
//                       return DisplayCard(item: item);
//                     },
//                   ),
//             if (showSearchHistory)
//               Positioned(
//                 top: 5, // Position below the AppBar
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   constraints: BoxConstraints(maxHeight: 150), // Limit height
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: searchHistory.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(searchHistory[index]),
//                         onTap: () {
//                           setState(() {
//                             searchQuery = searchHistory[index].toLowerCase();
//                             _onSearchSubmitted(searchHistory[index]);
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         bottomNavigationBar: NavigationBarComponent(currentIndex: 0),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campusdiningapp_mobile/services/dtb_services.dart'; // FirestoreService
import 'package:campusdiningapp_mobile/model/meal_mdl.dart'; // Item model
import 'package:campusdiningapp_mobile/components/displayCard.dart'; // DisplayCard widget
import 'components/navBar.dart'; // Import your navigation bar component
import 'logPage_scratch.dart';
import 'package:campusdiningapp_mobile/profilePage.dart';

import 'components/rangeSlider.dart'; //* Filter: Range slider
import 'components/filterChip.dart'; //* Search History

void logout(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInPage()),
  );
}

class FilterChipExample extends StatefulWidget {
  final List<String> choices;
  final ValueChanged<String> onSortChanged;

  const FilterChipExample({super.key, required this.choices, required this.onSortChanged});

  @override
  _FilterChipExampleState createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  String? selectedChoice;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: widget.choices.map((choice) {
        return FilterChip(
          label: Text(choice),
          selected: selectedChoice == choice,
          onSelected: (isSelected) {
            setState(() {
              selectedChoice = isSelected ? choice : null;
            });
            widget.onSortChanged(choice);  // Pass the selected choice back
          },
        );
      }).toList(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Item> items = [];
  bool isLoading = true;
  String searchQuery = '';
  List<String> searchHistory = [];
  RangeValues _currentRangeValues = const RangeValues(20, 300);
  bool showSearchHistory = false;
  String? selectedSortOption;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _loadSearchHistory(); // Load search history when the page is loaded
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

  Future<void> _loadSearchHistory() async {
    List<String> history = await FirestoreService().fetchSearchHistory();
    setState(() {
      searchHistory = history;
    });
  }

  void _onSearchSubmitted(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        searchQuery = query.toLowerCase();
      });

      // Save search history to Firestore and update local searchHistory
      await FirestoreService().saveSearchHistory(query);
      await _loadSearchHistory(); // Make sure history is refreshed after save
    } else {
      setState(() {
        searchQuery = '';
      });
    }
  }

  void _onSearchTapped() {
    setState(() {
      showSearchHistory =
          searchQuery.isEmpty; // Only show history if query is empty
    });
  }

  void _onTapOutside() {
    if (showSearchHistory) {
      setState(() {
        showSearchHistory = false;
      });
    }
  }

  // Sorting function
  void _onSortChanged(String choice) {
    setState(() {
      selectedSortOption = choice;
    });

    if (choice == 'A-Z') {
      items.sort((a, b) => a.name.compareTo(b.name));
    } else if (choice == 'Z-A') {
      items.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Item> filteredItems = items.where((item) {
      bool matchesName = item.name.toLowerCase().contains(searchQuery);
      bool withinPriceRange = item.price >= _currentRangeValues.start &&
          item.price <= _currentRangeValues.end;

      return matchesName && withinPriceRange;
    }).toList();

    return GestureDetector(
      onTap: _onTapOutside, // Dismiss dropdown when tapping outside
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: _onSearchTapped, // Toggle history on tap
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
                  onSubmitted: _onSearchSubmitted,
                  onTap: _onSearchTapped, // Show search history when tapped
                ),
              ],
            ),
          ),
          backgroundColor: Colors.teal,
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(
                    child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sort by price:'),
                      PriceRangeSlider(
                        initialRangeValues: _currentRangeValues,
                        onRangeChanged: (RangeValues newRange) {
                          setState(() {
                            _currentRangeValues = newRange;
                          });
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sort by name: '),
                          const SizedBox(height: 5),
                          Center(
                            child: FilterChipExample(
                              choices: const ['A-Z', 'Z-A'],
                              onSortChanged: _onSortChanged, // Pass the sorting logic
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => logout(context),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      var item = filteredItems[index];
                      return DisplayCard(item: item);
                    },
                  ),
            if (showSearchHistory)
              Positioned(
                top: 5, // Position below the AppBar
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(maxHeight: 150), // Limit height
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(searchHistory[index]),
                        onTap: () {
                          setState(() {
                            searchQuery = searchHistory[index].toLowerCase();
                            _onSearchSubmitted(searchHistory[index]);
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: NavigationBarComponent(currentIndex: 0),
      ),
    );
  }
}

