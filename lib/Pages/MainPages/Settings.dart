// ignore_for_file: prefer_if_null_operators, unused_field, prefer_const_constructors

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Class/snackbarClass.dart';

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
  List<DeliveryClass> dataReceived = [];
  List<DeliveryClass> dataFood = [];
  final storage = const FlutterSecureStorage();
  ScrollController scrollController = ScrollController();
  var message = "";
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
          if (mounted) {
            setState(() {
              var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
              data = List<DeliveryClass>.from(jsonData['tmp_packet_deliveries']
                  .map((item) => DeliveryClass.fromJson(item)));
              dataReceived = List<DeliveryClass>.from(
                  jsonData['packet_deliveries']
                      .map((item) => DeliveryClass.fromJson(item)));
              dataFood = List<DeliveryClass>.from(jsonData['food_deliveries']
                  .map((item) => DeliveryClass.fromJson(item)));
            });
          }
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

  // annuler une course debut
  Future<void> cancelledDelivery(int id) async {
    try {
      final String urlCancel =
          "http://$ipAdress:8080/client/tmppacketdelivery/$id/canceled_delivery/";
      final String? accessToken = await storage.read(key: 'access_token');
      if (accessToken != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        };
        var response = await http.patch(Uri.parse(urlCancel), headers: headers);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('PATCH request successful');
          setState(() {
            message = "Course annuler avec succès";
          });
          // ignore: use_build_context_synchronously
          SnackbarService.showSnackbar(context, message);

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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getTmpdelive();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      getTmpdelive();
    });
  }

  // annuler une course fin
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTmpdelive();
    initFirebaseMessaging();
  }

  @override
  void dispose() {
    FirebaseMessaging.onMessage.listen(null); // Annuler l'écoute
    FirebaseMessaging.onMessageOpenedApp.listen(null); // Annuler l'écoute
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);

    return SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
            height: screenSize.height * 1.5,
            child: Container(
              decoration: BoxDecoration(
                  color: Kwhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kraduis),
                      topRight: Radius.circular(kraduis))),
              child: Column(
                children: [
                  if (data.isEmpty)
                    Center(
                      // Si la liste est vide, affichez l'image centrée
                      child:
                          sizebox10, // Remplacez 'assets/empty_list_image.png' par le chemin de votre image
                    )
                  else
                    SizedBox(
                      height: screenSize.height * 0.40,
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final result = data[index];
                            final id = result.id;
                            final status = result.state;
                            final date3 = result.date_3;

                            final dateFormatter =
                                DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');

                            final dateTime = dateFormatter.parse(date3);
                            final dayMonthFormat = DateFormat('d MMM');
                            final abbreviatedMonth =
                                dayMonthFormat.format(dateTime);

                            final hourMinuteFormat = DateFormat('HH:mm');
                            final hourMinute =
                                hourMinuteFormat.format(dateTime);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, left: 10.0, right: 10.0),
                              child: Container(
                                width: screenSize.width * 0.75,
                                height: screenSize.height * 0.12,
                                decoration: ShapeDecoration(
                                  color: const Color(0x99FFCB74),
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
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: [
                                                  Text(id.toString()),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: [
                                                  if (status == '1')
                                                    const SizedBox(
                                                        child: Text(
                                                            'recherche livreur...',
                                                            style: TextStyle(
                                                                color:
                                                                    kstatusbtncolor,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 15))),
                                                  if (status == '0')
                                                    const SizedBox(
                                                        child: Text(
                                                      'Annuler',
                                                      style: kStyle,
                                                    )),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      '$abbreviatedMonth $hourMinute'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30.0,
                                      ),
                                      const Spacer(),
                                      if (status == '1')
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, bottom: 8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  cancelledDelivery(id);
                                                  setState(() {
                                                    getTmpdelive();
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        kstatusbtncolor,
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
                    ),
                  SizedBox(
                    height: screenSize.height * 0.40,
                    child: Column(
                      children: [
                        Text('Race delivery'),
                        Expanded(
                          child: ListView.builder(
                              controller: scrollController,
                              itemCount: dataReceived.length,
                              itemBuilder: (context, index) {
                                final result = dataReceived[index];
                                final id = result.id;
                                final status = result.state;
                                final date3 = result.date_3;
                                final date4 = result.date_4;

                                final dateFormatter =
                                    DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');

                                final dateTime = dateFormatter.parse(date4);
                                final dayMonthFormat = DateFormat('d MMM');
                                final abbreviatedMonth =
                                    dayMonthFormat.format(dateTime);

                                final hourMinuteFormat = DateFormat('HH:mm');
                                final hourMinute =
                                    hourMinuteFormat.format(dateTime);
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, left: 10.0, right: 10.0),
                                  child: Container(
                                    width: screenSize.width * 0.75,
                                    height: screenSize.height * 0.12,
                                    decoration: ShapeDecoration(
                                      color: const Color(0x99FFCB74),
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
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(id.toString()),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Row(
                                                    children: [
                                                      if (status == '1')
                                                        const SizedBox(
                                                            child: Text(
                                                                'recherche livreur...',
                                                                style: TextStyle(
                                                                    color:
                                                                        kstatusbtncolor,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        15))),
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
                                                              fontFamily:
                                                                  'Poppins',
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          '$abbreviatedMonth $hourMinute'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30.0,
                                          ),
                                          Spacer(),
                                          if (status == '1')
                                            SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0, bottom: 8.0),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      cancelledDelivery(id);
                                                      setState(() {
                                                        getTmpdelive();
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                kstatusbtncolor,
                                                            foregroundColor:
                                                                Kwhite),
                                                    child: Text("Annuler")),
                                              ),
                                            ),
                                          if (status == '0')
                                            SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0, bottom: 8.0),
                                                child: ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text("Relancer")),
                                              ),
                                            ),
                                          if (status != '1' && status != '0')
                                            const SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0, bottom: 8.0),
                                                child: ElevatedButton(
                                                    onPressed: null,
                                                    child: Text("Annuler")),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  if (dataFood.isEmpty)
                    Center(
                        // Si la liste est vide, affichez l'image centrée
                        child: Text(
                            "food delivery 0") // Remplacez 'assets/empty_list_image.png' par le chemin de votre image
                        )
                  else
                    SizedBox(
                      height: screenSize.height * 0.45,
                      child: Column(
                        children: [
                          Text("food delivery"),
                          Expanded(
                            child: ListView.builder(
                                controller: scrollController,
                                itemCount: dataFood.length,
                                itemBuilder: (context, index) {
                                  final result = dataFood[index];
                                  final id = result.id;
                                  final status = result.state;
                                  final date3 = result.date_3;
                                  final date4 = result.date_4;

                                  final dateFormatter =
                                      DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');

                                  final dateTime = dateFormatter.parse(date4);
                                  final dayMonthFormat = DateFormat('d MMM');
                                  final abbreviatedMonth =
                                      dayMonthFormat.format(dateTime);

                                  final hourMinuteFormat = DateFormat('HH:mm');
                                  final hourMinute =
                                      hourMinuteFormat.format(dateTime);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, left: 10.0, right: 10.0),
                                    child: Container(
                                      width: screenSize.width * 0.75,
                                      height: screenSize.height * 0.12,
                                      decoration: ShapeDecoration(
                                        color: const Color(0x99FFCB74),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenSize.width * 0.45,
                                              height: screenSize.height * 0.11,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Text(id.toString()),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Row(
                                                      children: [
                                                        if (status == '1')
                                                          const SizedBox(
                                                              child: Text(
                                                                  'recherche livreur...',
                                                                  style: TextStyle(
                                                                      color:
                                                                          kstatusbtncolor,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          15))),
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
                                                                fontFamily:
                                                                    'Poppins',
                                                                color:
                                                                    ksuccess),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            '$abbreviatedMonth $hourMinute'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 30.0,
                                            ),
                                            Spacer(),
                                            if (status == '1')
                                              SizedBox(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0,
                                                          bottom: 8.0),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        cancelledDelivery(id);
                                                        setState(() {
                                                          getTmpdelive();
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  kstatusbtncolor,
                                                              foregroundColor:
                                                                  Kwhite),
                                                      child: Text("Annuler")),
                                                ),
                                              ),
                                            if (status == '0')
                                              SizedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.0, bottom: 8.0),
                                                  child: ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text("Relancer")),
                                                ),
                                              ),
                                            if (status != '1' && status != '0')
                                              const SizedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.0, bottom: 8.0),
                                                  child: ElevatedButton(
                                                      onPressed: null,
                                                      child: Text("Annuler")),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            )));
  }
}
