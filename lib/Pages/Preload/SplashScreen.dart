// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/Login-Register/LoginPage.dart';
import 'package:d_bla_client_v1/Pages/MainPages/MainPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // fonction pour verifier si l'utilisateur est deja connecter et ouvrir une page en consequence
  void checkIslogin() async {
    const storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
          fullscreenDialog: true,
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
          fullscreenDialog: true,
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      checkIslogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);
    return Scaffold(
      body: Center(
        child: Container(
          height: screenSize.height * 0.5,
          color: Kwhite,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenSize.height * 0.4,
                  width: screenSize.width * 0.8,
                  child: Image.asset("assets/images/logo.png"),
                ),
                sizebox30,
                const Expanded(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE9A74e),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
