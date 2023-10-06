// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/CommandePage.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TypeofActivity {
  final int id;
  final String logo;
  final String name;
  final int tarif;
  TypeofActivity({
    required this.id,
    required this.logo,
    required this.name,
    required this.tarif,
  });
  factory TypeofActivity.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') &&
        json.containsKey('logo') &&
        json.containsKey('name') &&
        json.containsKey('tarif')) {
      return TypeofActivity(
        id: json['id'],
        logo: json['logo'],
        name: json['name'],
        tarif: json['tarif'],
      );
    } else {
      print(
          'Erreur lors de la désérialisation du JSON : certaines propriétés manquent ou ont des valeurs inattendues.');
      print('JSON complet : $json');
      return TypeofActivity(
        id: 0,
        logo: '',
        name: '',
        tarif: 0,
      );
    }
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<TypeofActivity> data = [];

  Future<void> getTypeofActivity() async {
    try {
      const String apiUrl = "http://192.168.1.71:8080/dbapp/type/";
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          var jsonData = jsonDecode(response.body);
          data = List<TypeofActivity>.from(
              jsonData['results'].map((item) => TypeofActivity.fromJson(item)));
        });
        print(response.body);
      } else {
        print("Erreur : ${response.statusCode}");
      }
    } catch (error) {
      debugPrint('Erreur lors de la recupperation de l\'api => $error');
    }
  }

  Future<void> getAccessToken() async {
    final storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'access_token');
    final String? username = await storage.read(key: 'user_name');
    print('token principal: $accessToken');
    print(
        'nom principal: $username'); // Ajoutez cette ligne pour afficher dans le débogueur
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTypeofActivity();
    getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    final globalVariableModel = Provider.of<GlobalVariableModel>(context);
    Size screenSize = calculateScreenSize(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
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
                  child: Center(
                    child: Text(
                      "De quoi avez-vous besoin aujourd’hui ?",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenSize.height * 0.15 * 0.15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    height: screenSize.height * 0.75 * 0.35,
                    child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final result = data[index];
                          final typename = result.name;
                          final logo = result.logo;
                          final idRace = result.id;

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    print("ouverture de page en cours");
                                    // globalVariableModel.setRaceId(idRace);
                                    globalVariableModel.setIdRace(idRace);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RacePage()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            KPrimaryColor, // Couleur de la bordure
                                        width: 2.0, // Largeur de la bordure
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      maxRadius: screenSize.width * 0.12,
                                      // backgroundImage: NetworkImage(
                                      //   "http://192.168.1.71:8000/" + logo,
                                      // ),
                                      child: Image.network(
                                          "http://192.168.1.71:8080/" + logo),
                                    ),
                                  ),
                                ),
                              ),
                              Text(typename)
                            ],
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print('Sodjigaz tap');
                        },
                        child: Container(
                          height: screenSize.height * 0.15,
                          width: screenSize.width * 0.45,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.green, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Image.asset(
                            "assets/images/Sodjigaz.png",
                            // width: screenSize.width * 0.2 * 2,
                            // height: screenSize.width * 0.2 * 0.9,
                            // width: 125,
                            // height: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 8)),
                      InkWell(
                        onTap: () {
                          print('Enora tap');
                        },
                        child: Container(
                          height: screenSize.height * 0.15,
                          width: screenSize.width * 0.45,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              // color: Colors.red,
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Image.asset(
                            "assets/images/enora.png",

                            // width: screenSize.width * 0.2 * 2,
                            // height: screenSize.width * 0.2 * 0.9,
                            // width: 125,
                            // height: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
