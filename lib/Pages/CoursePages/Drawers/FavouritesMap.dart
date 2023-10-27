// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:d_bla_client_v1/Constants/Constant.dart';
// import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/VerificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Addfavorite {
  final double latitude;
  final double longitude;
  final String name;
  final String adresse;

  Addfavorite(this.latitude, this.longitude, this.name, this.adresse);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'adresse': adresse,
    };
  }
}

class FavoriteMapPage extends StatefulWidget {
  const FavoriteMapPage({
    super.key,
  });

  @override
  State<FavoriteMapPage> createState() => _FavoriteMapPageState();
}

class _FavoriteMapPageState extends State<FavoriteMapPage> {
  TextEditingController searchController = TextEditingController();
  Position? currentPosition;
  List<Marker> markers = [];
  List<Marker> markerInit = [];
  // Marker? currentMarker;
  LatLng center = LatLng(0.0, 0.0);
  LatLng val1 = LatLng(0.0, 0.0);
  LatLng val2 = LatLng(0.0, 0.0);
  List<dynamic> searchResults = []; // recherche tableau
  List<dynamic> placeInfo = []; // geocoding tableau
  List<dynamic> details = []; // geocoding tableau
  bool isLoading =
      true; // pour reacharger la carte au moment ou on recupere le centre
  bool pos1Vald = false; // pour pourvoir changer la premiere position
  bool pos2Vald = false; // "" la deuxieme position
  bool isInfoWindowVisible = false; // info si on clique sur un lieu
  bool searching = false;
  MapController mapControllerM = MapController(); // controller du map
  // PopupController popupControllerM = PopupController();
  double infoWindowTop = 0.0;
  final FocusNode focusNode = FocusNode();
  var placename = "";

  var textMe = "Adresse de départ";
// fin
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
    markerInitial2();
  }

  // geocoding api  --debut
  Future<void> goePlace(String namePlace) async {
    final String apiUrl =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$namePlace.json?limit=1&access_token=pk.eyJ1Ijoid3Vhc3MiLCJhIjoiY2xtNTBpZmc1MWc1ejNqczZoeWw3bnh1dyJ9.RofiqR1hTvyAys4YHibAWQ";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final placeinfo = json.decode(response.body);
      setState(() {
        placeInfo = placeinfo['features'];
      });

      // print(' donneer geocoder de $namePlace : $placeinfo');

      if (placeInfo.isNotEmpty) {
        double latitude = placeInfo[0]['geometry']['coordinates'][1];
        double longitude = placeInfo[0]['geometry']['coordinates'][0];
        // print("latitude : $latitude");
        mapControllerM.move(LatLng(latitude, longitude), 14.0);

        if (!pos1Vald) {
          markers.clear();
          markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(latitude, longitude),
              builder: (ctx) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            ),
          );
          final markerPixelPos =
              mapControllerM.latLngToScreenPoint(LatLng(latitude, longitude));
          infoWindowTop = markerPixelPos!.y - 122;
          if (infoWindowTop < 0) {
            infoWindowTop =
                markerPixelPos.y + 10; // Ajustez la valeur en conséquence
          }
          isInfoWindowVisible = true;
          var lat2 = LatLng(latitude, longitude).latitude;
          var long2 = LatLng(latitude, longitude).longitude;
          val2 = LatLng(lat2, long2);
          viewInfoAdresse(lat2, long2);
        } else {}
      }
    } else {
      print(' erreur code : ${response.statusCode}');
    }
  }
  // geocoding api  --fin

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  void markerInitial2() {
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: center,
        builder: (ctx) => Container(
          child: Icon(
            Icons.location_on,
            size: 30,
            color: Colors.red,
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

  Future<void> viewInfoAdresse(double latitude, longitude) async {
    final urlApi =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json?country=tg&limit=1&types=address%2Cregion%2Ccountry%2Clocality%2Cneighborhood&access_token=pk.eyJ1Ijoic2VhcmNoLW1hY2hpbmUtdXNlci0xIiwiYSI6ImNrNnJ6bDdzdzA5cnAza3F4aTVwcWxqdWEifQ.RFF7CVFKrUsZVrJsFzhRvQ";
    final response = await http.get(Uri.parse(urlApi));
    if (response.statusCode == 200) {
      final request = json.decode(response.body);
      setState(() {
        details = request['features'];
      });
      if (details.isNotEmpty) {
        String text = details[0]['text'];
        setState(() {
          placename = text;
        });
      }
      print(
          "les donnée recucupere grace a $longitude et $latitude sont = $request ");
    } else {
      print('Statut code = ${response.body}');
    }
  }

// final storage = FlutterSecureStorage();
  final storage = FlutterSecureStorage();

  Future<void> storeDataInLocalStorage(
      double position2Stocker7, double position2Stocker3) async {
    try {
      await storage.write(
          key: "position_10", value: position2Stocker3.toString());
      await storage.write(
          key: "position_20", value: position2Stocker7.toString());
      print('Données stockées avec succès sous la clé: $position2Stocker3');
    } catch (e) {
      print('Erreur lors de la sauvegarde des données: $e');
    }
  }

  Future<void> storeDataInLocalStorage2(
      double position2Stocker700, double position2Stocker300) async {
    try {
      await storage.write(
          key: "position_100",
          value: position2Stocker300.toString()); //longitude
      await storage.write(
          key: "position_200",
          value: position2Stocker700.toString()); // latitude
      print('Données stockées avec succès sous la clé: $position2Stocker300');
    } catch (e) {
      print('Erreur lors de la sauvegarde des données: $e');
    }
  }

// fonction pour ajouter une postion favorite
// == debut ===/
  var message = "";
  TextEditingController favController =
      TextEditingController(); // controller pour le champ du nom du lieu
  Future<void> addFavorite(double latitudeF, double longitudeF, String nameF,
      String adresseF) async {
    try {
      if (favController.text.isEmpty) {
        setState(() {
          message = "Veuillez donnée un nom a votre position";
        });
        _showSnackbar(context, message);
      } else {
        const String apiFav = "http://$ipAdress:8080/dbapp/location/";
        final String? accessToken = await storage.read(key: 'access_token');
        if (accessToken != null) {
          final Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          };
          final favData = Addfavorite(latitudeF, longitudeF, nameF, adresseF);
          final jsonData = favData.toJson();
          final response = await http.post(Uri.parse(apiFav),
              headers: headers, body: jsonEncode(jsonData));

          final Map<String, dynamic> result = json.decode(response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            debugPrint('la reponse retourné est => $result');
            setState(() {
              message = "Position enregistrer avec succès";
              favController.text = "";
            });

            // ignore: use_build_context_synchronously
            _showSnackbar(context, message);
          } else {
            debugPrint('Status code => ${response.statusCode}');
          }
        } else {}
      }
    } catch (error) {
      debugPrint('erreur ue lors de la capture de l\'api => $error');
    }
  }

// == fin ===/
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
                            if (!pos1Vald) {
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
                              var lat2 = latLng.latitude;
                              var long2 = latLng.longitude;
                              print("latitude=>$lat2");
                              print("longitude=>$long2");
                              val2 = LatLng(lat2, long2);
                              storeDataInLocalStorage2(lat2, long2);
                              viewInfoAdresse(lat2, long2);
                            } else {
                              // valeur stoker; // valeur stoker
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
                          markers: markers,
                        ),
                        if (isInfoWindowVisible)
                          Positioned(
                            top: infoWindowTop,
                            left: 10,
                            right: 10,
                            child: Container(
                              width: screenSize.width / 4,
                              decoration: BoxDecoration(
                                // color: kBoxColor,
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          placename,
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
              initialChildSize: 0.4,
              maxChildSize: 0.4,
              minChildSize: 0.2,
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            height: screenSize.height / 15,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: TextField(
                              focusNode: focusNode,
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
                              sizebox20,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: screenSize.height * 0.20 * 0.30,
                                  width: screenSize.width,
                                  child: TextField(
                                    controller: favController,
                                    decoration: InputDecoration(
                                        hintText: 'Entrez un nom ',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)))),
                                  ),
                                ),
                              ),
                              sizebox20,
                              SizedBox(
                                width: screenSize.width * 0.75,
                                height: screenSize.height * 0.20 * 0.40,
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
                                        addFavorite(
                                            val2.latitude,
                                            val2.longitude,
                                            favController.text,
                                            placename);
                                      },
                                      child: Text(
                                        'Enregistrer',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 23),
                                      )),
                                ),
                              )
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
                                      InkWell(
                                        onTap: () {
                                          goePlace(name);
                                          searchController.text = "";
                                          focusNode.unfocus();
                                        },
                                        child: Container(
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
                                                    "Lomé-$country_name",
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                            ],
                                          ),
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
