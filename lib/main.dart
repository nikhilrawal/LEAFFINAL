import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leafapp/pages/homepage/bottomNav.dart';

// Hive box name and keys
const String authBoxName = 'authBox';
const String usernameKey = 'username';
const String passwordKey = 'password';
const String isLoggedInKey = 'isLoggedIn';
const String isSubscribedKey = 'isSubscribed';

Future<void> initHive() async {
  await Hive.initFlutter();
  await Hive.openBox(authBoxName);
  await Hive.openBox('user');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Health App',
      home: const Bottomnav(), // Directly set BottomNav as home screen
      debugShowCheckedModeBanner: false,
    );
  }
}
