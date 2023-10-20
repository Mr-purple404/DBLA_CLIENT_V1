import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/RaceModel.dart';
import 'package:d_bla_client_v1/Pages/Preload/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      // home: const SplashPage(),
      home: const HomeDav(),
    );
  }
}

class HomeDav extends StatefulWidget {
  const HomeDav({super.key});

  @override
  State<HomeDav> createState() => _HomeDavState();
}

class _HomeDavState extends State<HomeDav> {
  TextEditingController tokenController = TextEditingController();
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("############ TOKEN #######");
    print(deviceToken);
    setState(() {
      tokenController.text = deviceToken;
    });

    print("############ TOKEN #######");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
        title: Text("Flutter firebase 1st"),
      ),
      body: Center(
        child: TextField(
          controller: tokenController,
        ),
      ),
    );
  }

  Future getDeviceToken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    await _firebaseMessage.requestPermission();
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }
}
