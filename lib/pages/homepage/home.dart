import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:leafapp/pages/chatbotui/chat.dart';
import 'package:leafapp/pages/login/admin_login.dart';
import 'package:leafapp/pages/profile/profile.dart';
import 'package:leafapp/pages/scananddetect/add_wallpaper.dart';
import 'package:leafapp/pages/subsciption/subciption.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> assetImages = [
    'images/plant1.jpg',
    'images/plant2.jpg',
    'images/plant3.jpg',
    'images/plant4.jpg',
  ];
  int activeIndex = 0;
  bool search = true; // Changed to true since we're using local assets

  @override
  void initState() {
    super.initState();
    // Shuffle the images randomly when the app starts
    assetImages.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 20, right: 10, left: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Icon with PopupMenuButton
                  PopupMenuButton<String>(
                    icon: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(60),
                      shadowColor: Colors.blue,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Icon(Icons.menu, size: 35),
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 'login') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminLogin()),
                        );
                      } else if (value == 'profile') {
                        // Add profile navigation here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      } else if (value == 'subscribe') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionScreen(),
                          ),
                        );
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'login',
                            child: Text('Login'),
                          ),
                          PopupMenuItem<String>(
                            value: 'subscribe',
                            child: Text('Subscribe'),
                          ),
                          PopupMenuItem<String>(
                            value: 'profile',
                            child: Text('Profile'),
                          ),
                        ],
                  ),

                  // Title - Changed to Plant Health App
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      WavyAnimatedText(
                        'Plant Health App',
                        speed: Duration(milliseconds: 500),
                        textStyle: TextStyle(
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              blurRadius: 0.3,
                              color: const Color.fromARGB(153, 0, 0, 0),
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TyperAnimatedText(
                        'Plant Health App',
                        speed: Duration(milliseconds: 500),
                        textStyle: TextStyle(
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              blurRadius: 0.3,
                              color: const Color.fromARGB(153, 0, 0, 0),
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),

                  // Chatbot Icon
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(60),
                    shadowColor: Colors.blue,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: IconButton(
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          // Navigate to chatbot screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(firsttime: true),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: assetImages.length,
                        itemBuilder: (context, index, realIndex) {
                          final res = assetImages[index];
                          return buildImage(context, res);
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          height: MediaQuery.of(context).size.height / 2.1,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: smoothIndicator(activeIndex, assetImages.length),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to scan page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddWallpaper(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(209, 0, 0, 0),
                          ),
                          child: SizedBox(
                            width: 280,
                            height: 50,
                            child: Center(
                              child: AnimatedTextKit(
                                totalRepeatCount: 6,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'Scan Now',
                                    speed: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                        255,
                                        248,
                                        243,
                                        243,
                                      ),
                                      fontSize: 24,
                                      shadows: [
                                        Shadow(
                                          color: const Color.fromARGB(
                                            255,
                                            237,
                                            235,
                                            235,
                                          ),
                                          offset: Offset(0.5, 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget smoothIndicator(int activeIndex, int count) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: SlideEffect(
        dotWidth: 15,
        dotHeight: 15,
        activeDotColor: Colors.blue,
      ),
    );
  }

  Widget buildImage(BuildContext context, String res) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height / 1.7,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(res, fit: BoxFit.cover, scale: 2),
      ),
    );
  }
}
