// ignore_for_file: prefer_const_constructors

import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:d_bla_client_v1/Pages/CoursePages/Signaler.dart';
import 'package:flutter/material.dart';

import '../CoursePages/Drawers/SettingsPage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Drawer drawerPrincipale(BuildContext context, Size screenSize) {
  return Drawer(
    backgroundColor: Colors.black,
    child: ListView(
      children: [
        SizedBox(
          height: screenSize.height * 0.20,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Salut, John',
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 30, color: Kwhite),
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.wallet,
            size: 35,
            color: Kwhite,
          ),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "2780 F CFA",
              style:
                  TextStyle(color: Kwhite, fontFamily: 'Poppins', fontSize: 25),
            ),
          ),
          subtitle: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Portefeuille",
              style: TextStyle(color: Kwhite),
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.fifteen_mp,
            size: 35,
            color: Kwhite,
          ),
          subtitle: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Promotions",
              style: TextStyle(color: Kwhite),
            ),
          ),
        ),
        Divider(),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
                fullscreenDialog: true,
              ),
            );
          },
          leading: Icon(
            Icons.settings,
            size: 35,
            color: Kwhite,
          ),
          subtitle: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Paramètres",
              style: TextStyle(color: Kwhite),
            ),
          ),
        ),
        Divider(),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportPage()),
            );
          },
          subtitle: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Signaler",
              style: TextStyle(color: Kwhite),
            ),
          ),
        ),
        Divider(),
      ],
    ),
    // elevation: 100,
  );
}
