// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../MainPages/FirstPage.dart';

class EndRacePage extends StatefulWidget {
  const EndRacePage({super.key});

  @override
  State<EndRacePage> createState() => _EndRacePageState();
}

class _EndRacePageState extends State<EndRacePage> {
  List<TypeofActivity> data = [];
  final storage = FlutterSecureStorage();
  int selectedItemId = 0;
  Future<void> getTypeofActivity() async {
    try {
      const String apiUrl = "http://$ipAdress:8080/dbapp/type/";
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

  String priceView = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTypeofActivity();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final globalVariableModel = Provider.of<GlobalVariableModel>(context);
    selectedItemId = globalVariableModel.idRace;
    priceView = globalVariableModel.price;
  }

  Future<void> callDeliver(int id) async {
    try {
      final String urlCall =
          "http://$ipAdress:8080/client/tmppacketdelivery/$id/call_delivery/";
      final String? accessToken = await storage.read(key: 'access_token');
      if (accessToken != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        };
        var response = await http.patch(Uri.parse(urlCall), headers: headers);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('PATCH request successful');
          print(response.body);
        } else {
          print('PATCH request failed with ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } else {
        print('token inexistant $accessToken ');
      }
    } catch (e) {
      debugPrint('Erreur capturé => $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);
    final globalVariableModel = Provider.of<GlobalVariableModel>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: KPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
      ),
      body: SizedBox(
        height: screenSize.height * 0.75,
        width: screenSize.width,
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.1,
            ),
            SizedBox(
              height: screenSize.height * 0.2,
              width: screenSize.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                        width: screenSize.width * 0.4,
                        child: Text(
                          'Estimation',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
                        )),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: screenSize.width * 0.5,
                        height: screenSize.width * 0.17,
                        decoration: BoxDecoration(
                            border: Border.all(color: KPrimaryColor)),
                        child: Column(
                          children: [
                            Text(globalVariableModel.idRacing.toString()),
                            Text(globalVariableModel.price),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height: screenSize.height * 0.3,
                child: ListView.builder(
                  itemCount: data
                      .length, // Utilisez la liste de données récupérée depuis l'API
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final logo = item.logo;
                    // Obtenez l'élément de la liste
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItemId = item.id;
                          globalVariableModel.setIdRace(selectedItemId);
                          // globalVariableModel.setPrice(newPrice)
                          // Mettez à jour l'ID dans globalVariableModel
                        });
                        print('$selectedItemId');
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Image.network("http://$ipAdress:8080/$logo"),
                        ),
                        title: Text(item.name),
                        tileColor: globalVariableModel.idRace == item.id
                            ? KPrimaryColor
                            : null,
                      ),
                    );
                  },
                )),
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
                      callDeliver(globalVariableModel.idRacing);
                    },
                    child: Text(
                      ' Lancer la course',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 25),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
