import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'admin_page.dart';

class AdminLoginPage extends StatefulWidget {
  AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final passwordController = TextEditingController();

  void checkPassword() {
    if (passwordController.text == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Incorrect Password"),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/images/logo.png",
                  height: 125,
                ),

                const SizedBox(height: 25),

                // welcome back, you've been missed!
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Admin password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                MyButton(
                  onTap: checkPassword,
                  text: 'Sign In',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
