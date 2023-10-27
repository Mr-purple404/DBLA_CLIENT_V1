import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:d_bla_client_v1/Pages/Preload/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          GlobalVariableModel(), // Créez une instance du modèle de données
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  init() async {
    String deviceToken = await getDeviceToken();
    const storage = FlutterSecureStorage();
    await storage.write(key: 'instance_token', value: deviceToken);

    print("############ TOKEN #######");
    print(deviceToken);

    print("############ TOKEN #######");
  }

  Future getDeviceToken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    await _firebaseMessage.requestPermission();
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D-BLA client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      // home: const HomeDav(),
    );
  }
}
