import 'package:cafeconnect/components/my_button.dart';
import 'package:cafeconnect/components/my_textfield.dart';
import 'package:cafeconnect/services/auth_service.dart';
import 'package:flutter/material.dart';

class phoneVerificationPage extends StatelessWidget {
  const phoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumber = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Image.asset(
                "lib/images/logo.png",
                height: 125,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text("Phone Verification"),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: phoneNumber,
                  hintText: "12345 67890",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),

              // verify button
              MyButton(
                  onTap: () => AuthService()
                      .signInWithPhoneNumber(context, phoneNumber.text),
                  text: "Get code")
            ]),
          ),
        )));
  }
}
