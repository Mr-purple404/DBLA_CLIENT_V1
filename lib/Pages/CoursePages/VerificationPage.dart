// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/ConfirmationPage.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    super.key,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController slugController = TextEditingController();
  TextEditingController depPhoneController =
      TextEditingController(); // departure phone champ

  LatLng? latLng;
  LatLng? latLng200;
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
  // text et icon
  // debut
//  ion et text e changeable si on valide une position
  var iconCustommer = Icon(
    Icons.location_pin,
    color: Colors.red,
    size: 40,
  );
  var custommerText = "Où livrer votre colis ?";
  var iconMe = Icon(
    Icons.location_pin,
    color: Colors.green,
    size: 40,
  );
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
    markerInitial();
    getDistanceonly(position1.latitude, position1.longitude, position2.latitude,
        position2.longitude);
  }

  // geocoding api  --debut

  // geocoding api  --fin

  LatLng position1 =
      LatLng(0.0, 0.0); // Variable pour stocker la LatLng récupérée
  LatLng position2 = LatLng(0.0, 0.0);
  final storage = FlutterSecureStorage();
  Future<void> _loadLatLngFromStorage() async {
    try {
      final latitudeString = await storage.read(key: 'position_20');
      final longitudeString = await storage.read(key: 'position_10');

      if (latitudeString != null && longitudeString != null) {
        final latitude = double.tryParse(latitudeString);
        final longitude = double.tryParse(longitudeString);

        if (latitude != null && longitude != null) {
          setState(() {
            latLng = LatLng(latitude, longitude);
            position1 = latLng!;
          });
          print('position14464646: $position1');
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  Future<void> _loadLatLngFromStorage2() async {
    try {
      final latitudeString1 = await storage.read(key: 'position_200');
      final longitudeString1 = await storage.read(key: 'position_100');

      if (latitudeString1 != null && longitudeString1 != null) {
        final latitude100 = double.tryParse(latitudeString1);
        final longitude100 = double.tryParse(longitudeString1);

        if (latitude100 != null && longitude100 != null) {
          setState(() {
            latLng200 = LatLng(latitude100, longitude100);
            position2 = latLng200!;
          });
          print('supper: $position2');
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  Future<void> storeTmp(String distance, String slug) async {
    try {
      await storage.write(key: "distanceStocker", value: distance);
      await storage.write(key: "slug", value: slug);

      print("distance $distance et slug $slug enregistré");
    } catch (e) {
      print("erreur lors du stockage des clé => $e");
    }
  }

  File? imagepath;
  ImagePicker imagePicker = ImagePicker();

  Future<void> getImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (getimage != null) {
        imagepath = File(getimage.path);
        print(imagepath);
      }
    });
  }

  Future<void> getImagecamera() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (getimage != null) {
        imagepath = File(getimage.path);
        print(imagepath);
      }
    });
  }

  void showdialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kFormColor,
        title: Text('selectionez :'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Icon(
                  Icons.photo,
                  size: 50,
                )),
            GestureDetector(
                onTap: () {
                  getImagecamera();
                },
                child: Icon(
                  Icons.camera,
                  size: 50,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Ok',
              style: TextStyle(fontFamily: 'Poppins', color: kBlack),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDistanceonly(
      double firstLat, double firstLong, double endLat, double endLong) async {
    try {
      final distanceApi =
          "https://api.mapbox.com/directions/v5/mapbox/driving-traffic/$firstLong%2C$firstLat%3B$endLong%2C$endLat?alternatives=true&geometries=polyline&language=fr&overview=simplified&roundabout_exits=true&steps=true&voice_instructions=true&voice_units=metric&access_token=$mapboxKey";
      final response = await http.get(Uri.parse(distanceApi));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final duration = decodedResponse['routes'][0]['duration_typical'];
        final distance = decodedResponse['routes'][0]['distance'];
        final heures = duration ~/ 3600;
        final reste =
            duration % 3600; // Division entière pour obtenir les heures
        final minutes =
            reste ~/ 60; // Division entière pour obtenir les minutes
        final secondes = reste % 60; // Le reste est en secondes
        final seconde = secondes.toStringAsFixed(0);
        print('Durée : ${heures}h ${minutes}min ${seconde}s');
        print('duree => $duration');
        final durreeReel = distance / 1000;
        final tempsF = durreeReel.toStringAsFixed(1);
        print('distance => $distance');
        print('tempF => $tempsF');
        setState(() {
          distanceController.text = tempsF;
        });
      } else {}
    } catch (error) {
      print('erreur lors de la reccuperation de l\'api de distance => $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    // getPosition1FromStorage();
    _loadLatLngFromStorage();
    _loadLatLngFromStorage2();
  }

  void markerInitial() {
    print("====$position1");
    markerInit.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: position1,
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
    // print(" center : $centering");
  }

  void markerInitial2() {
    print('position2 = $position2');

    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: position2,
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);
    final globalVariableModel = Provider.of<GlobalVariableModel>(context);
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
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      'Distance',
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                    Container(
                                      height: screenSize.height / 15,
                                      width: screenSize.width / 4,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: TextField(
                                        readOnly: true,
                                        controller: distanceController,
                                        decoration: InputDecoration(
                                            hintText: '',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(padding: EdgeInsets.all(8.0)),

                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      "Estimation",
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                    Container(
                                      height: screenSize.height / 15,
                                      width: screenSize.width / 2.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: TextField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                            hintText: '',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: screenSize.height * 0.20 * 0.45,
                              width: screenSize.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 8.0,
                                    bottom: 4.0),
                                child: Text(
                                  "Cette estimation peut légèrement varier selon de  l’état de la circulation",
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: TextField(
                                  controller: depPhoneController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                    hintText: '98647161',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 60.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width,
                              height: screenSize.height * 0.20 * 0.70,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: slugController,
                                  minLines: 2,
                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintText: 'Note au livreur',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins1',
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Kwhite))),
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
                                      if (slugController.text.isEmpty) {
                                        storeTmp(distanceController.text, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmPage()),
                                        );
                                      } else {
                                        storeTmp(distanceController.text,
                                            slugController.text);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmPage()),
                                        );
                                      }
                                    },
                                    child: Text(
                                      ' Confirmer',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 25),
                                    )),
                              ),
                            ),
                          ],
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
