// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DeliveryClass {
  final int id;
  final String distance;
  final int engine;
  final String price_1;
  final String price_2;
  final String depature_adress;
  final String arrival_adress;
  final String date_3;
  final String date_4;
  final String state;
  DeliveryClass({
    required this.id,
    required this.distance,
    required this.engine,
    required this.price_1,
    required this.price_2,
    required this.depature_adress,
    required this.arrival_adress,
    required this.date_4,
    required this.date_3,
    required this.state,
  });
  factory DeliveryClass.fromJson(Map<String, dynamic> json) {
    try {
      return DeliveryClass(
        id: json['id'] as int,
        distance: json['distance'] as String,
        engine: json['engine'] as int,
        price_1: json['price_1'] as String,
        price_2: json['price_2'] as String,
        depature_adress: json['depature_adress'] as String,
        arrival_adress: json['arrival_adress'] as String,
        date_4: json['date_4'] as String? ?? '',
        date_3: json['date_3'],
        state: json['state'] as String,
      );
    } catch (e) {
      print('Erreur de désérialisation : $e');
      return DeliveryClass(
        id: 0,
        engine: 0,
        price_1: '',
        price_2: '',
        distance: '',
        arrival_adress: '',
        depature_adress: '',
        date_3: '',
        // ignore: unnecessary_null_comparison
        date_4: '',
        state: '',
      );
    }
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<DeliveryClass> data = [];
  final storage = const FlutterSecureStorage();
  ScrollController scrollController = ScrollController();
  Future<void> getTmpdelive() async {
    try {
      const String apiUrl = "http://$ipAdress:8080/client/historic/";

      final String? accessToken = await storage.read(key: 'access_token');

      if (accessToken != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        };
        var response = await http.get(Uri.parse(apiUrl), headers: headers);
        if (response.statusCode == 200) {
          setState(() {
            var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
            data = List<DeliveryClass>.from(jsonData['tmp_packet_deliveries']
                .map((item) => DeliveryClass.fromJson(item)));
          });
          print(" ===========RESPONSE================");
          print(" response => ${response.body}");
          print(" ===========RESPONSE================");
        } else {
          print("Erreur : ${response.statusCode}");
        }
      } else {
        print("token innacessible");
      }
    } catch (error) {
      debugPrint('Erreur lors de la recupperation de l\'api => $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTmpdelive();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);

    return SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
            height: screenSize.height * 0.70,
            child: Container(
              decoration: BoxDecoration(
                  color: Kwhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kraduis),
                      topRight: Radius.circular(kraduis))),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final result = data[index];
                    final id = result.id;
                    final status = result.state;
                    final date3 = result.date_3;
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      child: Container(
                        width: screenSize.width * 0.75,
                        height: screenSize.height * 0.12,
                        decoration: ShapeDecoration(
                          color: Color(0x99FFCB74),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.45,
                                height: screenSize.height * 0.11,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Text(date3),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          if (status == '1')
                                            const SizedBox(
                                                child: Text(
                                                    'recherche livreur...',
                                                    style: TextStyle(
                                                        color: kstatusbtncolor,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 15))),
                                          if (status == '2')
                                            const SizedBox(
                                                child: Text(
                                              'Livreur en route',
                                            )),
                                          if (status == '3')
                                            const SizedBox(
                                                child: Text(
                                              'En cours',
                                              style: kStyle,
                                            )),
                                          if (status == '4')
                                            const SizedBox(
                                                child: Text(
                                              'Arrivé',
                                              style: kStyle,
                                            )),
                                          if (status == '5')
                                            const SizedBox(
                                                child: Text(
                                              'Livré',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: ksuccess),
                                            )),
                                          if (status == '6')
                                            const SizedBox(
                                                child: Text(
                                              'Retourné',
                                              style: kStyle,
                                            )),
                                          if (status == '0')
                                            const SizedBox(
                                                child: Text(
                                              'Annuler',
                                              style: kStyle,
                                            )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              const SizedBox(
                                width: 1.0,
                                height: 50.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Spacer(),
                              if (status == '1')
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 8.0),
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kstatusbtncolor,
                                            foregroundColor: Kwhite),
                                        child: Text("Annuler")),
                                  ),
                                ),
                              if (status != '1')
                                const SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 10.0, bottom: 8.0),
                                    child: ElevatedButton(
                                        onPressed: null,
                                        // style: ElevatedButton.styleFrom(
                                        //     backgroundColor: kstatusbtncolor,
                                        //     foregroundColor: Kwhite),
                                        child: Text("Annuler")),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }
}
