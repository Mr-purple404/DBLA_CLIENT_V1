// ignore_for_file: prefer_const_constructors

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/Constant.dart';

import '../../MainPages/DrawerPage.dart';

// class ReportData {
//   final String user;
//   final String content;

//   ReportData(this.user, this.content);

//   Map<String, dynamic> toJson() {
//     return {
//       'user': user,
//       'content': content,
//     };
//   }
// }

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController reportController = TextEditingController();
  var message = '';
  var montant = '725';
  var cleCourse = "H9 - KJ2X";
  // Future<void> sendReport() async {
  //   try {
  //     const String apiReport = "http://$ipAdress:8080/client/report/";
  //     if (reportController.text.isEmpty) {
  //       setState(() {
  //         message = "Veuillez remplir le champ avant d'envoyer ";
  //       });
  //       _showSnackbar(context, message);
  //     } else {
  //       final storage = FlutterSecureStorage();
  //       final String? accessToken = await storage.read(key: 'access_token');
  //       final String? idUser = await storage.read(key: 'id_User');

  //       if (accessToken != null && idUser != null) {
  //         final Map<String, String> headers = {
  //           'Authorization': 'Bearer $accessToken',
  //           'Content-Type': 'application/json',
  //         };
  //         final reportData = ReportData(idUser, reportController.text);
  //         final jsonData = reportData.toJson();
  //         final response = await http.post(Uri.parse(apiReport),
  //             headers: headers, body: jsonEncode(jsonData));
  //         final Map<String, dynamic> responseData2 = json.decode(response.body);
  //         if (response.statusCode == 200 || response.statusCode == 201) {
  //           print('${responseData2}');
  //           setState(() {
  //             message = "Probleme envoyé avec succès";
  //           });
  //           // ignore: use_build_context_synchronously
  //           _showSnackbar(context, message);
  //           reportController.text = "";
  //         } else {
  //           print("erreur code : ${response.statusCode}");
  //         }
  //       } else {
  //         print("token ou id indisponible token $accessToken , id => $idUser");
  //       }
  //     }
  //   } catch (error) {
  //     debugPrint("Erreur suite a la reccupération de l'api => $error");
  //   }
  // }

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
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height * 0.05,
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
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 300,
                                  height: 200,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 1.0,
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            topRight: Radius.circular(50))),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: SizedBox(
                                      width: 300.0,
                                      height: 50.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: kPromoColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50),
                                                topRight: Radius.circular(50))),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.75,
                      height: screenSize.height * 0.20 * 0.50,
                      // child: Padding(
                      //   padding: const EdgeInsets.only(bottom: 5.0),
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: kstatusbtncolor,
                      //         foregroundColor: Kwhite,
                      //         elevation: 4, // Définir l'élévation ici
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(
                      //               10.0), // Définir la forme du bouton ici
                      //         ),
                      //       ),
                      //       onPressed: () {},
                      //       child: Text(
                      //         ' Valider',
                      //         style: TextStyle(
                      //             fontFamily: 'Poppins', fontSize: 25),
                      //       )),
                      // ),
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
