import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logPage_scratch.dart';// Import the logPage.dart file
import 'logPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GetStartedScreen(),
  ));
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStartedScreen(),
    );
  }
}

class GetStartedScreen extends StatelessWidget {
  final List<String> images = [
    'assets/background.jpg',
    'assets/background3.jpg',
    'assets/background4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: ImageSlider(images: images),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                    
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                      
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 16), 
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Text(
                      "Already created an account? Sign in here",
                      style: TextStyle(
                        color: Colors.blue, // Styling it like a link
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ImageSlider extends StatefulWidget {
  final List<String> images;

  ImageSlider({required this.images});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Start automatic sliding
    Future.delayed(Duration(seconds: 2), _autoSlide);
  }

  void _autoSlide() {
    if (_pageController.hasClients) {
      setState(() {
        // Move to the next page, or loop back to the first page
        currentIndex = (currentIndex + 1) % widget.images.length;
        _pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }

    // Continue auto sliding after a delay
    Future.delayed(Duration(seconds: 2), _autoSlide);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return Image.asset(
          widget.images[index],
          fit: BoxFit.cover,
          width: double.infinity,
        );
      },
    );
  }
}
