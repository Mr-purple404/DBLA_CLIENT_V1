// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../../Constants/Constant.dart';

import '../../MainPages/ClassFav.dart';
import '../../MainPages/DrawerPage.dart';
import 'FavouritesMap.dart';

// classe pour extraire les postions favorites
// == debut ==//

// == fin ==//
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController reportController = TextEditingController();
  var message = '';
  List<FavPostionClass> favList = []; // une liste pour l'extraction
  final storage = FlutterSecureStorage();
// fonction pour l'affichage des postion
// == debut ==//
  Future<void> getFavotiteList() async {
    try {
      const String apiUrl = "http://$ipAdress:8080/dbapp/location/";
      final String? accessToken = await storage.read(key: 'access_token');

      if (accessToken != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        };
        var response = await http.get(Uri.parse(apiUrl), headers: headers);
        if (response.statusCode == 200) {
          setState(() {
            var jsonData = jsonDecode(response.body);
            favList = List<FavPostionClass>.from(jsonData['results']
                .map((item) => FavPostionClass.fromJson(item)));
          });
          print(response.body);
        } else {
          print("Erreur : ${response.statusCode}");
        }
      } else {
        print("token inexistant => $accessToken");
      }
    } catch (error) {
      debugPrint('Erreur lors de la recupperation de l\'api => $error');
    }
  }
// == fin ==//

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavotiteList();
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
                      height: screenSize.height * 0.03,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.15 * 0.4,
                      width: screenSize.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconButton(
                          //     onPressed: () => Navigator.pop(context),
                          //     icon: Icon(Icons.arrow_back)),
                          Center(
                            child: Text(
                              "Paramètres",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.height * 0.15 * 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: screenSize.height * 0.1,
                        width: screenSize.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 30,
                                color: KPrimaryColor,
                              ),
                              Text(
                                'Positions Favorites',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 22),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  print('tape');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FavoriteMapPage(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: kstatusbtncolor,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FavoriteMapPage(),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Kwhite,
                                      )),
                                ),
                              )
                            ],
                          ),
                        )),
                    Divider(),
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height * 0.40,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: ListView.builder(
                            itemCount: favList.length,
                            itemBuilder: (context, index) {
                              final result = favList[index];
                              final placeName = result.name;
                              final idPlace = result.id;
                              final adresse = result.adresse;
                              return SizedBox(
                                width: screenSize.width,
                                height: screenSize.height * 0.18,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: SizedBox(
                                          width: screenSize.width * 0.2,
                                          child: Text(
                                            placeName,
                                            style: TextStyle(
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: SizedBox(
                                          width: screenSize.width * 0.6,
                                          child: Container(
                                            width: screenSize.width * 0.6,
                                            height: screenSize.height * 0.15,
                                            decoration: ShapeDecoration(
                                              color: kBoxColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Column(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Text("data")
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
