import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leafapp/pages/homepage/bottomNav.dart';
// import 'package:leafapp/pages/homepage/home.dart';
// import 'package:leafapp/pages/login/a_i.dart';
// import 'package:leafapp/pages/scananddetect/add_wallpaper.dart';
import 'package:leafapp/pages/login/create_acount.dart';

// Hive box name and keys
const String authBoxName = 'authBox';
const String usernameKey = 'username';
const String passwordKey = 'password';
const String isLoggedInKey = 'isLoggedIn';

class AdminLogin extends StatefulWidget {
  final bool ai;
  const AdminLogin({super.key, this.ai = false});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> fkey = new GlobalKey<FormState>();
  TextEditingController usernameCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  late Box authBox;

  @override
  void initState() {
    super.initState();
    _initHive();
    _checkAutoLogin();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    authBox = await Hive.openBox(authBoxName);
  }

  Future<void> _checkAutoLogin() async {
    await Future.delayed(
      Duration(milliseconds: 300),
    ); // Small delay for Hive init
    if (authBox.get(isLoggedInKey, defaultValue: false) == true) {
      // If already logged in, navigate to home page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Kindly Logout first from Profile Screen'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav()),
      );
    } else {
      // If not logged in, stay on login page
      setState(() {}); // Trigger rebuild to show login form
    }
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
      backgroundColor: Color(0xFFededeb),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(194, 15, 15, 15),
                    const Color.fromARGB(224, 14, 10, 10),
                    const Color.fromARGB(255, 0, 0, 0),
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
              padding: EdgeInsets.only(top: 20),
              margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Form(
                key: fkey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Login to talk\nwith our doctors",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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
                            SizedBox(height: 50),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 155, 155, 47),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: usernameCtrl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter valid username";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Username',
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 155, 155, 47),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: passwordCtrl,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter valid password";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                                      _login();
                                    }
                                  },
                                  child: Text(
                                    'Login',
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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 105, 105, 105),
                  ),
                  height: 100,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCreate(),
                          ),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: "Create now",
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

  Future<void> _login() async {
    final authBox = Hive.box(authBoxName);
    final savedUsername = authBox.get(usernameKey);
    final savedPassword = authBox.get(passwordKey);

    if (usernameCtrl.text == savedUsername &&
        passwordCtrl.text == savedPassword) {
      // Save login state
      await authBox.put(isLoggedInKey, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Login Successful'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
