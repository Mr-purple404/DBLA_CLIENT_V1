// ignore_for_file: prefer_const_constructors

import 'dart:convert';

// import 'package:d_bla_client_v1/Pages/MainPages/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/Login-Register/RegisterPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:d_bla_client_v1/Pages/MainPages/MainPage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var message = "";
  Future<void> validDate() async {
    try {
      const String apiToken = "http://192.168.1.71:8080/client/token";
      if (mailController.text.isEmpty) {
        setState(() {
          message = 'Veuillez remplir le champs email';
        });
        _showSnackbar(context, message);
      } else if (passwordController.text.isEmpty) {
        setState(() {
          message = "Veuillez remplir le chap mot de passe";
        });
        _showSnackbar(context, message);
      } else {
        final Map<String, String> dataLogin = {
          'username': mailController.text,
          'password': passwordController.text,
        };
        final response = await http.post(
          Uri.parse(apiToken),
          body: dataLogin,
        );
        final Map<String, dynamic> result = json.decode(response.body);
        final storageLogin = const FlutterSecureStorage();
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (result['access'] != "") {
            final String accessToken = result['access'];
            final String username = mailController.text;
            await storageLogin.write(key: 'access_token', value: accessToken);
            await storageLogin.write(key: 'user_name', value: username);

            debugPrint(' access token :$accessToken');
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
                fullscreenDialog: true,
              ),
            );
          }
        } else {
          if (response.statusCode == 401) {
            setState(() {
              message = "identifant incorrect";
            });
            print(response.statusCode);
            _showSnackbar(context, message);
          } else {
            debugPrint("code d'erreur reccupéré  : ${response.statusCode}");
          }
        }
      }
    } catch (error) {
      debugPrint("erreur lors de la reccuperation de l'api => $error");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // fonction pour naviguer vers la page d'inscription
  void goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(
        context); // obtenir la taille du telephone la fonction  calculateScreenSize est defini dans le constant.dart

    return Scaffold(
      backgroundColor: KPrimaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.20,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "D-bla",
                        style: TextStyle(
                            fontFamily:
                                'Conforter', // conforter nom de la police defin dans le pubsec yaml
                            fontSize: 40,
                            color: Kwhite),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          onPressed: () => goToRegister(),
                          icon: Icon(
                            Icons.person_add_alt_1,
                            color: Kwhite,
                            size: 35,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: screenSize.height * 0.75,
                width: screenSize.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                        spreadRadius: 5, // Écart de l'ombre
                        blurRadius: 7, // Flou de l'ombre
                        offset: Offset(0, 1), // Décalage de l'ombre (en bas)
                      ),
                    ],
                    color: Kwhite,
                    borderRadius: BorderRadius.all(Radius.circular(kraduis))),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.75 * 0.25,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenSize.width * 0.89,
                      height: screenSize.height * 0.75 * 0.15,
                      decoration: BoxDecoration(
                          color: kFormColor.withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(
                              50)) // Bordure pour visualiser le Container
                          ),
                      child: Align(
                        alignment: Alignment
                            .center, // Alignement au centre du Container
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 30.0, left: 30.0, right: 30.0),
                          child: TextFormField(
                            controller: mailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.75 * 0.05,
                    ),
                    // sizebox20 est une constant defini dans le fichier constant.dart
                    Container(
                      width: screenSize.width * 0.89,
                      height: screenSize.height * 0.75 * 0.15,
                      decoration: BoxDecoration(
                          color: kFormColor.withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(
                              50)) // Bordure pour visualiser le Container
                          ),
                      child: Align(
                        alignment: Alignment
                            .center, // Alignement au centre du Container
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 30.0, left: 30.0, right: 30.0),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText: 'Mot de passe',
                            ),
                            // keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.75 * 0.09,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HomeScreen(),
                        //     fullscreenDialog: true,
                        //   ),
                        // );
                        validDate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kbtnColor,
                        elevation: 4, // Définir l'élévation ici
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Définir la forme du bouton ici
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            12.0), // Définir les marges internes du bouton
                        child: Text(
                          'valider'.toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: kBlack,
                              letterSpacing: 3),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
