// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RacePage extends StatefulWidget {
  const RacePage({
    super.key,
  });

  @override
  State<RacePage> createState() => _RacePageState();
}

class _RacePageState extends State<RacePage> {
  TextEditingController searchController = TextEditingController();
  Position? currentPosition;
  List<Marker> markers = [];
  List<Marker> markerInit = [];
  // Marker? currentMarker;
  LatLng center = LatLng(0.0, 0.0);
  LatLng val1 = LatLng(0.0, 0.0);
  LatLng val2 = LatLng(0.0, 0.0);
  List<dynamic> searchResults = [];

  bool isLoading = true;
  bool pos1Vald = false;
  bool pos2Vald = false;
  bool isInfoWindowVisible = false;
  bool searching = false;
  MapController mapControllerM = MapController();
  // PopupController popupControllerM = PopupController();
  double infoWindowTop = 0.0;

  Future<void> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // L'utilisateur a refusé la permission
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // L'utilisateur a définitivement refusé la permission
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
      center = LatLng(currentPosition!.latitude, currentPosition!.longitude);

      isLoading = false;
      val1 = center;
    });
    print(" centre : $center");
    print(" position : $currentPosition");
    markerInitial();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  void markerInitial() {
    markerInit.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: center,
        builder: (ctx) => Container(
          child: Icon(
            Icons.location_on,
            size: 30,
            color: Colors.green,
          ),
        ),
      ),
    );
    setState(() {
      pos1Vald = false;
      pos2Vald = false;
    });
  }

  List data = ["Maison", "bureau", "Maman H", "favorites"];

  Future<void> searchPlace(String query) async {
    // final String bbox = '-0.235,5.5,1.9,11.5';
    final String endPoint =
        'https://api.mapbox.com/search/searchbox/v1/suggest?q=$query&access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrNnJ6bDdzdzA5cnAza3F4aTVwcWxqdWEifQ.RFF7CVFKrUsZVrJsFzhRvQ&session_token=ec5c1e5c-ecf9-4a3b-8de5-73dc3bc22290&language=fr&limit=10&types=country%2Cregion%2Cdistrict%2Cpostcode%2Clocality%2Cplace%2Cneighborhood%2Caddress%2Cpoi%2Cstreet&proximity=1.2440902%2C6.1908137&country=tg&eta_type=navigation&origin=1.24412,6.190781';
    final response = await http.get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        searchResults = data['suggestions'];
      });
      print("statut code : ${response.statusCode}");
      print("statut code : ${response.body}");
    } else {
      print("statut code : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);
    // final globalVariableModel = Provider.of<GlobalVariableModel>(context);
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: KPrimaryColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Kwhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kraduis),
                      topRight: Radius.circular(kraduis))),
              height: screenSize.height * 0.70,
              width: screenSize.width,
              child: isLoading
                  ? Center(
                      // Affichez un indicateur de chargement tant que _isLoading est vrai
                      child: Text(""),
                    )
                  : FlutterMap(
                      mapController: mapControllerM,
                      options: MapOptions(
                        onTap: (details, latLng) {
                          setState(() {
                            if (pos1Vald == false) {
                              markerInit.clear();

                              markerInit.add(
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: latLng,
                                  builder: (ctx) => Container(
                                    child: Icon(
                                      Icons.location_on,
                                      size: 30,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              );
                              // final markerPixelPos = mapControllerM
                              //     .latLngToScreenPoint(latLng);
                              // infoWindowTop = markerPixelPos!.x - 100;
                              final markerPixelPos =
                                  mapControllerM.latLngToScreenPoint(latLng);
                              infoWindowTop = markerPixelPos!.y - 122;
                              if (infoWindowTop < 0) {
                                // Si la fenêtre d'information est en dehors de l'écran vers le haut,
                                // réajustez la position pour qu'elle soit juste en dessous du marqueur
                                infoWindowTop = markerPixelPos.y +
                                    10; // Ajustez la valeur en conséquence
                              }
                              isInfoWindowVisible = true;
                              var lat1 = latLng.latitude;
                              var long1 = latLng.longitude;
                              val1 = LatLng(lat1, long1); // valeur stoker
                            } else {
                              if (!pos2Vald) {
                                markers.clear();

                                markers.add(
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: latLng,
                                    builder: (ctx) => Container(
                                      child: Icon(
                                        Icons.location_on,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                                var lat2 = latLng.latitude;
                                var long2 = latLng.longitude;
                                val2 = LatLng(lat2, long2);
                              }
                            }
                          });
                        },
                        center: center,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/wuass/clmf1bl3q01fs01qx2sfmhigw/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoid3Vhc3MiLCJhIjoiY2xtNTBpZmc1MWc1ejNqczZoeWw3bnh1dyJ9.RofiqR1hTvyAys4YHibAWQ',
                          additionalOptions: const {
                            'accessToken':
                                'pk.eyJ1Ijoid3Vhc3MiLCJhIjoiY2xtNTBpZmc1MWc1ejNqczZoeWw3bnh1dyJ9.RofiqR1hTvyAys4YHibAWQ',
                          },
                        ),
                        MarkerLayer(
                          markers: markerInit,
                        ),
                        MarkerLayer(
                          markers: markers,
                        ),
                        if (isInfoWindowVisible)
                          Positioned(
                            top: infoWindowTop,
                            left: 10,
                            right: 10,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "data",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isInfoWindowVisible = false;
                                              });
                                            },
                                            icon: Icon(Icons.close))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          Positioned(
              top: 10, // Position verticale
              left: 0, // Position horizontale
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: Kwhite,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: kBlack,
                        ))),
              )),
          DraggableScrollableSheet(
              initialChildSize: 0.5,
              maxChildSize: 0.6,
              minChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollcontroller) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    height: screenSize.height * 0.10,
                    color: Kwhite,
                    child: ListView(
                      controller: scrollcontroller,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                              Expanded(
                                  child: Text(
                                'Où livrer votre colis ?',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 20),
                              )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: TextField(
                              controller: searchController,
                              onChanged: (query) {
                                if (query.isNotEmpty) {
                                  searchPlace(query);
                                } else {
                                  setState(() {
                                    searchResults = [];
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: '',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50)))),
                            ),
                          ),
                        ),
                        if (searchController.text.isEmpty)
                          Column(
                            children: [
                              SizedBox(
                                height: screenSize.height * 0.20 * 0.50,
                                width: screenSize.width,
                                child: ListView.builder(
                                    itemCount: data.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        margin: EdgeInsets.all(8.0),
                                        height: screenSize.height * 0.20 * 0.25,
                                        width: screenSize.width / 3.5,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0, right: 1.0),
                                              child: Icon(
                                                Icons.favorite,
                                                color: KPrimaryColor,
                                              ),
                                            ),
                                            Text(data[index]),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              Center(
                                  child: Text(
                                'Numéro du destinataire',
                                style: TextStyle(fontFamily: 'Poppins'),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, bottom: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: TextField(
                                    // controller: searchController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone_android,
                                        color: Colors.green,
                                        size: 35,
                                      ),
                                      hintText: '98647161',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 60.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width,
                                height: screenSize.height * 0.20 * 0.80,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kBoxColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            width: screenSize.width * 0.60,
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(right: 5.0)),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          if (!pos1Vald)
                                            SizedBox(
                                              height: screenSize.height *
                                                  0.20 *
                                                  0.70,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: kbtnColor,
                                                  foregroundColor: kBlack,
                                                  elevation:
                                                      4, // Définir l'élévation ici
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Définir la forme du bouton ici
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pos1Vald = true;
                                                    pos2Vald = false;
                                                  });
                                                },
                                                child: Text(
                                                  'confirmer',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          if (pos1Vald && pos2Vald == false)
                                            SizedBox(
                                              height: screenSize.height *
                                                  0.20 *
                                                  0.70,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: kbtnColor,
                                                  foregroundColor: kBlack,
                                                  elevation:
                                                      4, // Définir l'élévation ici
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Définir la forme du bouton ici
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pos1Vald = true;
                                                    pos2Vald = true;
                                                  });
                                                },
                                                child: Text(
                                                  'confirmer',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          if (pos1Vald && pos2Vald == true)
                                            SizedBox(
                                              height: screenSize.height *
                                                  0.20 *
                                                  0.70,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: kbtnColor,
                                                    foregroundColor: kBlack,
                                                    elevation:
                                                        4, // Définir l'élévation ici
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Définir la forme du bouton ici
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                  child:
                                                      Text('Valider course')),
                                            )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (searchResults.isNotEmpty)
                          SizedBox(
                            height: screenSize.height * 0.30,
                            child: ListView.builder(
                              controller: scrollcontroller,
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final suggestion = searchResults[index];
                                final name = suggestion['name'];
                                final category = suggestion['feature_type'];
                                final context = suggestion["context"];
                                final country = context["country"];
                                final country_name =
                                    country?["name"] ?? "pas de pays";
                                // return Card(
                                //   child: ListTile(
                                //     title: Text(name),
                                //     subtitle: Text(country_name),
                                //     onTap: () {
                                //       setState(() {
                                //         searchController.text = "";
                                //       });
                                //     },
                                //   ),
                                // );
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'),
                                                ),
                                                Text(
                                                  " Lomé-$country_name",
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: null,
                                                icon: Icon(Icons.favorite))
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 2,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
