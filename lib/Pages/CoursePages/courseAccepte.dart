// ignore_for_file: prefer_const_constructors

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/MainPages/DrawerPage.dart';
import 'package:flutter/material.dart';

class AcceptRacePage extends StatefulWidget {
  const AcceptRacePage({super.key});

  @override
  State<AcceptRacePage> createState() => _AcceptRacePageState();
}

class _AcceptRacePageState extends State<AcceptRacePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: KPrimaryColor,
      body: Column(
        children: [
          SizedBox(
            height: screenSize.height * 0.20,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "D-bla",
                    style: TextStyle(
                        fontFamily:
                            'Conforter', // conforter nom de la police defin dans le pubsec yaml
                        fontSize: 40,
                        color: Kwhite),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () {
                        print('Appuieeeeeee');
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Kwhite,
                        size: 35,
                      )),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back)),
                          Center(
                            child: Text(
                              "Livraison immediate",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.height * 0.15 * 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), // Affiche la page sélectionnée
        ],
      ),
      endDrawer: drawerPrincipale(context, screenSize),
    );
  }
}
