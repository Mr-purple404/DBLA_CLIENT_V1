// ignore_for_file: prefer_const_constructors

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/Constant.dart';

import '../../MainPages/DrawerPage.dart';

class PayData {
  final int phone;
  final int amount;
  final String network;

  PayData(this.phone, this.amount, this.network);

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'amount': amount,
      'network': network,
    };
  }
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController montantController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  var message = '';
  String _selectedGender = 'TMONEY';
  List<String> genderOptions = ['TMONEY', 'FLOOZ'];

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
  List montantShortcuts = [500, 1000, 2000, 5000, 10000];
  final storage = FlutterSecureStorage(); // pour faciliter le choix du montant
  Future<void> postAmount() async {
    try {
      if (numberController.text.isEmpty && montantController.text.isEmpty) {
        print("Veuillez remplir tout les champs!");
        setState(() {
          message = "Veuillez remplir tout les champs!";
        });
        _showSnackbar(context, message);
      } else {
        const String apiPay = "http://$ipAdress:8080/dbapp/pay/";
        final String? accessToken = await storage.read(key: 'access_token');
        if (accessToken != null) {
          final Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          };

          final int montant = int.parse(montantController.text);
          final int number = int.parse(numberController.text);

          final reportData = PayData(number, montant, _selectedGender);
          final jsonData = reportData.toJson();
          final response = await http.post(Uri.parse(apiPay),
              headers: headers, body: jsonEncode(jsonData));
          // final Map<dynamic, dynamic> responseData2 =
          //     json.decode(response.body);
          final Map<String, dynamic> result = json.decode(response.body);
          if (response.statusCode == 200) {
            debugPrint('la reponse retourné est => $result');
            setState(() {
              message = "1";
              montantController.text = "";
              numberController.text.isEmpty;
            });

            // ignore: use_build_context_synchronously
            _showSnackbar(context, message);
          } else {
            debugPrint("le code de l'erreur est ${response.statusCode}");
          }
        } else {
          debugPrint("token innexistant => $accessToken");
        }
      }
    } catch (e) {
      debugPrint("erreur reccuperer dans la fonction => $e");
    }
  }

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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 10.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Portefeuille",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: kstatusbtncolor),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenSize.width,
                              height: screenSize.height * 0.15,
                              decoration: BoxDecoration(
                                color: kstatusboxcolor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Solde",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins'),
                                            ),
                                            Text(
                                              "0.0",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: kstatusbtncolor,
                                              foregroundColor: Kwhite),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) => Container(
                                                      color: Kwhite,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                              width: screenSize
                                                                  .width,
                                                              height: screenSize
                                                                      .height *
                                                                  0.05),
                                                          SizedBox(
                                                            width: screenSize
                                                                .width,
                                                            height: screenSize
                                                                    .height *
                                                                0.75 *
                                                                0.20,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15.0),
                                                                child:
                                                                    DropdownButtonFormField<
                                                                        String>(
                                                                  value:
                                                                      _selectedGender, // Valeur sélectionnée
                                                                  items: genderOptions
                                                                      .map((String
                                                                          value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child: Text(value ==
                                                                              'TMONEY'
                                                                          ? 'TMONEY'
                                                                          : 'FLOOZ'),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      _selectedGender =
                                                                          newValue!;
                                                                    });
                                                                  },
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        'Opérateur',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenSize
                                                                .width,
                                                            height: screenSize
                                                                    .height *
                                                                0.75 *
                                                                0.20,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      15.0),
                                                              child: TextField(
                                                                controller:
                                                                    numberController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Entrez Votre numéro',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenSize
                                                                .width,
                                                            height: screenSize
                                                                    .height *
                                                                0.75 *
                                                                0.20,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      15.0),
                                                              child: TextField(
                                                                controller:
                                                                    montantController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Entrez le montant',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: screenSize
                                                                    .height *
                                                                0.20 *
                                                                0.50,
                                                            width: screenSize
                                                                .width,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        montantShortcuts
                                                                            .length,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final result =
                                                                          montantShortcuts[
                                                                              index];

                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            montantController.text =
                                                                                result.toString();
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade300,
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                          margin:
                                                                              EdgeInsets.all(8.0),
                                                                          height: screenSize.height *
                                                                              0.20 *
                                                                              0.25,
                                                                          width:
                                                                              screenSize.width / 3.5,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 3.0, right: 1.0),
                                                                                child: Icon(
                                                                                  Icons.circle,
                                                                                  color: KPrimaryColor,
                                                                                ),
                                                                              ),
                                                                              Text(montantShortcuts[index].toString()),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                          SizedBox(
                                                            width: screenSize
                                                                    .width *
                                                                0.75,
                                                            height: screenSize
                                                                    .height *
                                                                0.20 *
                                                                0.50,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5.0),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            kstatusbtncolor,
                                                                        foregroundColor:
                                                                            Kwhite,
                                                                        elevation:
                                                                            4, // Définir l'élévation ici
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0), // Définir la forme du bouton ici
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        postAmount();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        ' Valider',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                20),
                                                                      )),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ));
                                          },
                                          child: Text(
                                            "Recharger",
                                            style: kStyle,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width,
                              height: screenSize.height * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenSize.width * 0.35,
                                    height: screenSize.height * 0.18,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/tmoney.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenSize.width * 0.09),
                                  Container(
                                    width: screenSize.width * 0.35,
                                    height: screenSize.height * 0.18,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/flooz.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
