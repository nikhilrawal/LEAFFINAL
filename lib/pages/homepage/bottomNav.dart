import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:leafapp/pages/chatbotui/chatbothome.dart';
// import 'package:leafapp/pages/chatbotui/chattingtab/chatbott.dart';
import 'package:leafapp/pages/doctorstab/community.dart';
// import 'package:leafapp/pages/categories.dart';
import 'package:leafapp/pages/homepage/home.dart';
// import 'package:leafapp/pages/chatbotui/chattingtab/chatbott.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currIndex = 0;
  List<Widget> pages = [];
  late HomeScreen home;
  late HomePage chatbott;
  late Community community;
  late Widget currentPage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home = HomeScreen();
    chatbott = HomePage();
    currentPage = HomeScreen();
    community = Community();
    pages = [home, chatbott, community];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          buttonBackgroundColor: Colors.black,
          color: Color.fromARGB(255, 89, 89, 89),
          backgroundColor: Colors.white10,
          animationDuration: Duration(milliseconds: 800),
          onTap: (value) {
            setState(() {
              currIndex = value;
            });
          },
          items: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
            Icon(Icons.local_hospital_outlined, color: Colors.white),
          ],
        ),
        body: pages[currIndex],
      ),
    );
  }
}
