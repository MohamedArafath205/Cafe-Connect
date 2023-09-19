import 'package:cafeconnect/pages/phone_otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/home_page.dart';

class AuthService {
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn(
            clientId:
                "527892939651-pl5tdvu01ca0h4bdibe3ev6ufs9a2kp4.apps.googleusercontent.com")
        .signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, let's sign in the user
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    return await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? forceResendingToken) async {
          String smscode = '';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smscode);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => phoneOtpPage(
                        credentials: credential,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  verifyOTP(BuildContext context, credential, String userOTP) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: credential, smsCode: userOTP);
      User? user =
          (await FirebaseAuth.instance.signInWithCredential(creds)).user;
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      print(e);
    }
  }
}
