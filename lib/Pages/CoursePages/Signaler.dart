// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';

import 'package:d_bla_client_v1/Pages/MainPages/DrawerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ReportData {
  final String user;
  final String content;

  ReportData(this.user, this.content);

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'content': content,
    };
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController reportController = TextEditingController();
  var message = '';

  Future<void> sendReport() async {
    try {
      const String apiReport = "http://$ipAdress:8080/dbapp/report/";
      if (reportController.text.isEmpty) {
        setState(() {
          message = "Veuillez remplir le champ avant d'envoyer ";
        });
        _showSnackbar(context, message);
      } else {
        final storage = FlutterSecureStorage();
        final String? accessToken = await storage.read(key: 'access_token');
        final String? idUser = await storage.read(key: 'id_User');

        if (accessToken != null && idUser != null) {
          final Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          };
          final reportData = ReportData(idUser, reportController.text);
          final jsonData = reportData.toJson();
          final response = await http.post(Uri.parse(apiReport),
              headers: headers, body: jsonEncode(jsonData));
          final Map<String, dynamic> responseData2 = json.decode(response.body);
          if (response.statusCode == 200 || response.statusCode == 201) {
            print('${responseData2}');
            setState(() {
              message = "Probleme envoyé avec succès";
            });
            // ignore: use_build_context_synchronously
            _showSnackbar(context, message);
            reportController.text = "";
          } else {
            print("erreur code : ${response.statusCode}");
          }
        } else {
          print("token ou id indisponible token $accessToken , id => $idUser");
        }
      }
    } catch (error) {
      debugPrint("Erreur suite a la reccupération de l'api => $error");
    }
  }

  // snackbar debut
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // snackbar fin
  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: KPrimaryColor,
      body: Column(
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
                      onPressed: () {
                        print('Appuieeeeeee');
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Kwhite,
                        size: 35,
                      )),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: screenSize.height * 0.75,
                width: screenSize.width,
                decoration: BoxDecoration(
                    color: Kwhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kraduis),
                        topRight: Radius.circular(kraduis))),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.15 * 0.4,
                      width: screenSize.width,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back)),
                          Center(
                            child: Text(
                              "Nous Ecrire",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.height * 0.15 * 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: screenSize.width,
                        height: screenSize.height * 0.50,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        child: TextFormField(
                          controller: reportController,
                          minLines: 10,
                          maxLines: 15,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              hintText: 'Note au livreur',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins1',
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Kwhite))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.75,
                      height: screenSize.height * 0.20 * 0.50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kbtnColor,
                              foregroundColor: kBlack,
                              elevation: 4, // Définir l'élévation ici
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Définir la forme du bouton ici
                              ),
                            ),
                            onPressed: () {
                              sendReport();
                            },
                            child: Text(
                              ' Envoyer',
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 25),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ), // Affiche la page sélectionnée
        ],
      ),
      endDrawer: drawerPrincipale(context, screenSize),
    );
  }
}
