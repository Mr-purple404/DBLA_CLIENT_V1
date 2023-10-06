// ignore_for_file: prefer_const_constructors

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/Login-Register/LoginPage.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
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
                height: screenSize.height * 0.15,
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
                          onPressed: () => goToLogin(),
                          icon: Icon(
                            Icons.person,
                            color: Kwhite,
                            size: 35,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: screenSize.height * 0.80,
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
                      height: screenSize.height * 0.75 * 0.15,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Sign up',
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
                      height: screenSize.height * 0.75 * 0.02,
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
                      height: screenSize.height * 0.75 * 0.02,
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
                      height: screenSize.height * 0.75 * 0.02,
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
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),

                    // sizebox20 est une constant defini dans le fichier constant.dart

                    SizedBox(
                      height: screenSize.height * 0.75 * 0.09,
                    ),
                    ElevatedButton(
                      onPressed: () {},
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
                          'S\'inscrire'.toUpperCase(),
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
