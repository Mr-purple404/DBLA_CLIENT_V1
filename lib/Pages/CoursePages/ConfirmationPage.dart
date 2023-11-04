// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/ConfirmationPage.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/EndRace.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:full_screen_image/full_screen_image.dart';

class DeliveryClass {
  final int id;
  final String distance;
  final int engine;
  final String price_1;
  final String price_2;

  DeliveryClass({
    required this.id,
    required this.distance,
    required this.engine,
    required this.price_1,
    required this.price_2,
  });
  factory DeliveryClass.fromJson(Map<String, dynamic> json) {
    try {
      return DeliveryClass(
        id: json['id'] as int,
        distance: json['distance'] as String,
        engine: json['engine'] as int,
        price_1: json['price_1'] as String,
        price_2: json['price_2'] as String,
      );
    } catch (e) {
      print('Erreur de désérialisation : $e');
      return DeliveryClass(
        id: 0,
        engine: 0,
        price_1: '',
        price_2: '',
        distance: '',
      );
    }
  }
}

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({
    super.key,
  });

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  TextEditingController searchController = TextEditingController();
  LatLng? latLng;
  LatLng? latLng200;
  Position? currentPosition;
  List<Marker> markers = [];
  List<Marker> markerInit = [];
  // Marker? currentMarker;
  LatLng center = LatLng(0.0, 0.0);
  LatLng val1 = LatLng(0.0, 0.0);
  LatLng val2 = LatLng(0.0, 0.0);

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
  bool? ischecked = false;
  var message = '';
  LatLng position1 =
      LatLng(0.0, 0.0); // Variable pour stocker la LatLng récupérée
  LatLng position2 = LatLng(0.0, 0.0);
  var distanceF = "";
  var slugF = "";
  var numberA = "";
  var arrivalA = "";
  var arrivalP = "";
  var depAdre = "";
  String price2Final = '';
  int idFinal = 0;
  File? imagepath;
  ImagePicker imagePicker = ImagePicker();

  TextEditingController codeController = TextEditingController();

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
  }

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
          print('super: $position2');
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  Future<void> loadVal() async {
    try {
      final distance = await storage.read(key: 'distanceStocker');
      final numberdep = await storage.read(key: 'numberdep');
      final depAdresse = await storage.read(key: 'departure_adresse');
      final arrivalAdresse = await storage.read(key: 'arrival_adresse');
      final arrivalPhone = await storage.read(key: 'arrival_phone');
      final slug = await storage.read(key: 'slug');

      if (distance != null &&
          slug != null &&
          depAdresse != null &&
          arrivalAdresse != null &&
          arrivalPhone != null &&
          numberdep != null) {
        setState(() {
          distanceF = distance;
          slugF = slug;
          numberA = numberdep;
          arrivalA = arrivalAdresse;
          arrivalP = arrivalPhone;
          depAdre = depAdresse;
        });
        print(
            "distance => $distance && slug => $slug => $numberdep adresse => $depAdresse || $arrivalPhone ||$arrivalAdresse ||");
      } else {
        print('Variable null');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

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

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> onload(int idE) async {
    if (imagepath == null) {
      print("Aucune image sélectionnée.");
      setState(() {
        message = 'Aucune image sélectionnée.';
      });
      _showSnackbar(context, message);
    } else if (ischecked! && codeController.text.isEmpty) {
      print("Veuillez remplr le champ code promo");
      setState(() {
        message = 'Veuillez remplr le champ code promo.';
      });
      _showSnackbar(context, message);
      return;
    } else if (ischecked! && codeController.text.isNotEmpty) {
      try {
        final String? accessToken = await storage.read(key: 'access_token');

        if (accessToken != null) {
          final Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          };

          String url = "http://$ipAdress:8080/client/tmppacketdelivery/";
          var request = http.MultipartRequest('POST', Uri.parse(url));
          request.headers.addAll(headers);
          request.fields['distance'] = distanceF;
          request.fields['slug'] = slugF;
          request.fields['depature_latitude'] = position1.latitude.toString();
          request.fields['depature_longitude'] = position1.longitude.toString();
          request.fields['depature_adress'] = 'Bè-ahligo';
          request.fields['depature_phone'] = "1234567";
          request.fields['arrival_latitude'] = position2.latitude.toString();
          request.fields['arrival_longitude'] = position2.longitude.toString();
          request.fields['arrival_adress'] = 'grd Marché';
          request.fields['arrival_phone'] = "1234567";
          request.fields['engine'] = idE.toString();
          request.fields['client'] = "1";
          request.fields['code_promo'] = codeController.text;

          var imageFile =
              await http.MultipartFile.fromPath('picture', imagepath!.path);
          request.files.add(imageFile);

          var response = await request.send();
          if (response.statusCode == 200 || response.statusCode == 201) {
            var responseData = await response.stream.toBytes();
            var responseString = utf8.decode(responseData);
            print(responseString);

            setState(() {
              message = 'image uploader avec succès';
              imagepath = null;
            });
            _showSnackbar(context, message);
          } else {
            var responseData = await response.stream.toBytes();
            var responseString = utf8.decode(responseData);
            print('StatusCode => ${response.statusCode} && ${responseString} ');
          }
        } else {
          print('inexistant');
        }
      } catch (e) {
        print('erreur reccuperer => $e');
      }
    } else {
      try {
        final String? accessToken = await storage.read(key: 'access_token');

        if (accessToken != null) {
          final Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          };

          String url = "http://$ipAdress:8080/client/tmppacketdelivery/";
          var request = http.MultipartRequest('POST', Uri.parse(url));
          request.headers.addAll(headers);
          request.fields['distance'] = distanceF;
          request.fields['slug'] = slugF;
          request.fields['depature_latitude'] = position1.latitude.toString();
          request.fields['depature_longitude'] = position1.longitude.toString();
          request.fields['depature_adress'] = depAdre;
          request.fields['depature_phone'] = numberA;
          request.fields['arrival_latitude'] = position2.latitude.toString();
          request.fields['arrival_longitude'] = position2.longitude.toString();
          request.fields['arrival_adress'] = arrivalA;
          request.fields['arrival_phone'] = arrivalP;
          request.fields['engine'] = idE.toString();
          request.fields['client'] = "1";

          var imageFile =
              await http.MultipartFile.fromPath('picture', imagepath!.path);
          request.files.add(imageFile);

          var response = await request.send();
          if (response.statusCode == 200 || response.statusCode == 201) {
            var responseData = await response.stream.toBytes();
            var responseString = utf8.decode(responseData);
            print(responseString);

            var jsonData = jsonDecode(responseString);
            if (jsonData != null) {
              var delivery = DeliveryClass.fromJson(jsonData);

              // Vous pouvez maintenant accéder aux propriétés de la classe
              int id = delivery.id;
              String distance = delivery.distance;

              String price1 = delivery.price_1;
              String price2 = delivery.price_2;

              setState(() {
                price2Final = price2;
                idFinal = id;
                // final globalVariableModel =
                //     Provider.of<GlobalVariableModel>(context, listen: false);
                // globalVariableModel.setIdRacing(idFinal);
                final globalVariableModel =
                    Provider.of<GlobalVariableModel>(context, listen: false);
                globalVariableModel.setIdRacing(idFinal);
                globalVariableModel.setPrice(price2Final);
              });
              print(idFinal);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EndRacePage()));
              // Utilisez ces valeurs comme vous le souhaitez
            } else {
              // Gérez le cas où la désérialisation a échoué
              print("Erreur de désérialisation : $jsonData est null");
            }

            // 'print(responseString);'

            setState(() {
              message = 'Paramètres envoyé veuillez valider la course';
              imagepath = null;
            });
            _showSnackbar(context, message);
          } else {
            var responseData = await response.stream.toBytes();
            var responseString = utf8.decode(responseData);
            print('StatusCode => ${response.statusCode} && ${responseString} ');
          }
        } else {
          print('inexistant');
        }
      } catch (e) {
        print('erreur reccuperer => $e');
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    // getPosition1FromStorage();
    _loadLatLngFromStorage();
    _loadLatLngFromStorage2();
    loadVal();
  }

  late Timer _timer;
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
                                flex: 2,
                                child: Container(
                                  height: screenSize.height / 15,
                                  width: screenSize.width / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          value: ischecked,
                                          activeColor: kFormColor,
                                          // tristate: true,
                                          onChanged: (newBool) {
                                            setState(() {
                                              ischecked = newBool;
                                              // print(
                                              //     "La valeur de ischecked a été modifiée : $ischecked");
                                            });
                                          }),
                                      const Text(
                                        "Utiliser un code promo",
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Padding(padding: EdgeInsets.all(8.0)),

                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Container(
                                        height: screenSize.height / 15,
                                        width: screenSize.width / 3,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: TextField(
                                          controller: codeController,
                                          decoration: InputDecoration(
                                              hintText: 'code promo',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50)))),
                                        ),
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "Estimation en kilomètre",
                                          style:
                                              TextStyle(fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Container(
                                            height: screenSize.height / 15,
                                            width: screenSize.width / 3,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  hintText: '8km',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50)))),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Text(
                                          'image colis ',
                                          style:
                                              TextStyle(fontFamily: 'Poppins'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            height: screenSize.height / 5,
                                            width: screenSize.width / 3,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                            ),
                                            child: imagepath != null
                                                ? FullScreenWidget(
                                                    backgroundColor: Colors.red,
                                                    backgroundIsTransparent:
                                                        true,
                                                    disposeLevel:
                                                        DisposeLevel.High,
                                                    child:
                                                        Image.file(imagepath!))
                                                : InkWell(
                                                    onTap: () {
                                                      showdialog();
                                                    },
                                                    child: Icon(Icons.camera)),
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
                                        InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "course programée",
                                            style: TextStyle(
                                                fontFamily: 'Poppins'),
                                          ),
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width,
                              height: screenSize.height * 0.20 * 0.20,
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
                                      onload(globalVariableModel.idRace);
                                    },
                                    child: Text(
                                      'Valider paramètres',
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
