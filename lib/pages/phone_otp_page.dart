import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth_service.dart';

class phoneOtpPage extends StatefulWidget {
  final credentials;
  const phoneOtpPage({super.key, required this.credentials});

  @override
  State<phoneOtpPage> createState() => _phoneOtpPageState();
}

class _phoneOtpPageState extends State<phoneOtpPage> {
  @override
  Widget build(BuildContext context) {
    final user_otp = TextEditingController();
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
              const Text("Enter OTP"),
              const SizedBox(
                height: 10,
              ),
              // otp textfield
              MyTextField(
                  controller: user_otp,
                  hintText: "Enter OTP",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              // verify button
              MyButton(
                  onTap: () => AuthService()
                      .verifyOTP(context, widget.credentials, user_otp.text),
                  text: "Verify OTP")
            ]),
          ),
        )));
  }
}
