import 'package:d_bla_client_v1/Constants/Constant.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = calculateScreenSize(context);

    return SingleChildScrollView(
        child: SizedBox(height: screenSize.height * 0.10, child: Container()));
  }
}
