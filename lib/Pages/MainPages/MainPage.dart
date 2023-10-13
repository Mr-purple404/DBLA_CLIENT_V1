// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/MainPages/DrawerPage.dart';
import 'package:d_bla_client_v1/Pages/MainPages/FirstPage.dart';
import 'package:d_bla_client_v1/Pages/MainPages/Settings.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int selectIndex = 0;
  void _navigateBottom(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  final List<Widget> pages = [
    FirstPage(),
    SettingPage(),
  ];
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
            child: pages[selectIndex],
          ), // Affiche la page sélectionnée
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: KPrimaryColor,
          unselectedItemColor: Colors.blueGrey,
          fixedColor: Kwhite,
          currentIndex: selectIndex,
          onTap: _navigateBottom,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'Home'.toUpperCase()),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 30,
              ),
              label: 'historique'.toUpperCase(),
            ),
          ]),
      endDrawer: drawerPrincipale(context, screenSize),
    );
  }
}
