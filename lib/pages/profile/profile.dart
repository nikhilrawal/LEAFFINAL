import 'package:hive/hive.dart';
import 'package:leafapp/main.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final authBox = Hive.box(authBoxName);
    final userBox = Hive.box('user');
    await authBox.put(isLoggedInKey, false);
    await userBox.put(isSubscribedKey, false);
    // await authBox.delete(usernameKey);
    // await authBox.delete(passwordKey);

    // Navigate back or to login screen after logout
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box(authBoxName);
    final isLoggedIn = authBox.get(isLoggedInKey, defaultValue: false);
    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile'), centerTitle: true),
        body: Center(
          child: Text(
            'You are not logged in',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }
    final username = authBox.get(usernameKey, defaultValue: 'Not available');
    final password = authBox.get(passwordKey, defaultValue: 'Not available');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInfoCard('Email', username.toString()),
            const SizedBox(height: 15),
            _buildInfoCard('Password', password.toString()),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
