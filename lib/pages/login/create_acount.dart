import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leafapp/pages/login/admin_login.dart';

// Use the same box name and keys as in AdminLogin
const String authBoxName = 'authBox';
const String usernameKey = 'username';
const String passwordKey = 'password';
const String isLoggedInKey = 'isLoggedIn';

class AdminCreate extends StatefulWidget {
  const AdminCreate({super.key});

  @override
  State<AdminCreate> createState() => _AdminCreateState();
}

class _AdminCreateState extends State<AdminCreate> {
  final GlobalKey<FormState> fkey = GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  late Box authBox;
  String text1 = "Is Batman better than Superman? Click to know!";

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    authBox = await Hive.openBox(authBoxName);
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFededeb),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(194, 15, 15, 15),
                    Color.fromARGB(224, 14, 10, 10),
                    Color.fromARGB(255, 0, 0, 0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    110,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Form(
                key: fkey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Create an account without hassle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    155,
                                    155,
                                    47,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: usernameCtrl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a username";
                                    }
                                    if (value.length < 4) {
                                      return "Username must be at least 4 characters";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter unique username',
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    155,
                                    155,
                                    47,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: passwordCtrl,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a password";
                                    } else if (value.length != 4) {
                                      return "Password must be 4 digits";
                                    } else if (!RegExp(
                                      r'^[0-9]+$',
                                    ).hasMatch(value)) {
                                      return "Password must contain only digits";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter a 4 digit Password',
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    foregroundColor: Colors.black,
                                    minimumSize: Size(
                                      MediaQuery.of(context).size.width / 2.2,
                                      55,
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    if (fkey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      CreateAccount();
                                    }
                                  },
                                  child: const Text(
                                    'Create an account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
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
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Material(
                elevation: 2,
                shadowColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 105, 105, 105),
                  ),
                  height: 100,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLogin(),
                          ),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: "Login now",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                fontSize: 19,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 19,
                            shadows: [
                              Shadow(color: Colors.black, offset: Offset(1, 1)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> CreateAccount() async {
    try {
      final authBox = Hive.box(authBoxName);

      // Check if username already exists
      final existingUser = authBox.get(usernameKey);
      if (existingUser != null && existingUser == usernameCtrl.text) {
        throw 'Username already exists';
      }

      // Save credentials
      await authBox.put(usernameKey, usernameCtrl.text);
      await authBox.put(passwordKey, passwordCtrl.text.trim());
      await authBox.put(isLoggedInKey, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Auto-login after account creation
      // Navigator.pushReplacementNamed(context, '/');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
