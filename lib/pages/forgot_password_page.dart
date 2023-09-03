import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class ForgotPassword extends StatefulWidget {
  final Function()? onTap;
  ForgotPassword({super.key, required this.onTap});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // text editing controllers
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  // email verification
  emailVerification() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Email Sent. Check your mail inbox!"),
            );
          });
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.code);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // logo
                Image.asset(
                  "lib/images/logo.png",
                  height: 125,
                ),

                const SizedBox(height: 25),

                // welcome back, you've been missed!
                Text(
                  "Forgot Password? Don't worry we got you!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                MyButton(
                  onTap: emailVerification,
                  text: 'Send Request',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
