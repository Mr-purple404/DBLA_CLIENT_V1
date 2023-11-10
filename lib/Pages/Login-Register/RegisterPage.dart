// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/Login-Register/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Class/RegisterModel.dart';
import '../Class/snackbarClass.dart';

class EmailData {
  final String mail;

  EmailData(this.mail);

  Map<String, dynamic> toJson() {
    return {
      'mail': mail,
    };
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  TextEditingController birthdayController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String _val = '';
  var message = '';

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
        fullscreenDialog: true,
      ),
    );
  }

  Future _select_full_date() async {
    // DateTime eightyearsago = DateTime.now().subtract(Duration(days: 18 * 365));
    DateTime initialDate = DateTime(DateTime.now().year - 18, 1, 1);
    DateTime maxDate = DateTime(DateTime.now().year - 18, 12, 31);
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: maxDate,
    );

    if (picker != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picker);
      setState(() {
        _val = formattedDate;
        birthdayController.text = _val;
      });
    }
  }

  Future<void> sendInfo() async {
    try {
      const String urlSendMail = "http://$ipAdress:8080/dbapp/email/";
      if (birthdayController.text.isEmpty ||
          nameController.text.isEmpty ||
          firstnameController.text.isEmpty ||
          emailController.text.isEmpty) {
        setState(() {
          message = "Veuillez renseigner tout les champs";
        });
        SnackbarService.showSnackbar(context, message);
      } else {
        final Map<String, String> dataRegister = {'mail': emailController.text};

        final reportData = EmailData(emailController.text);
        final jsonData = reportData.toJson();
        final response =
            await http.post(Uri.parse(urlSendMail), body: dataRegister);
        final Map<String, dynamic> responseData2 = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print(responseData2);
          setState(() {
            message = "Donné valide";
            final globalRegisterModel =
                Provider.of<GlobalRegisterModel>(context, listen: false);
            globalRegisterModel.setNameCustommer(nameController.text);
            globalRegisterModel.setFirstNameCustommer(firstnameController.text);
            globalRegisterModel.setDateNaissance(birthdayController.text);
            globalRegisterModel.setEmailCustommmer(emailController.text);
          });
          SnackbarService.showSnackbar(context, message);
        } else {
          var responseString = utf8.decode(response.bodyBytes);
          print('StatusCode => ${response.statusCode} && ${responseString} ');
        }
      }
    } catch (e) {
      debugPrint('erreur  lors de la reccupération de l\'api => $e');
    }
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
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Nom',
                            ),
                            // keyboardType: TextInputType.emailAddress,
                            keyboardType: TextInputType.text,
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
                            controller: firstnameController,
                            decoration: InputDecoration(
                              hintText: 'Prénom',
                            ),
                            // keyboardType: TextInputType.emailAddress,
                            keyboardType: TextInputType.text,
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
                            controller: birthdayController,
                            decoration: InputDecoration(
                                hintText: 'date de naissance',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _select_full_date();
                                    },
                                    icon: Icon(Icons.calendar_month_outlined))),
                            // keyboardType: TextInputType.emailAddress,
                            keyboardType: TextInputType.datetime,
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
                            controller: emailController,
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
                      onPressed: () {
                        sendInfo();
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
