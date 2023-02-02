import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:mediscript/screens/landing_screen.dart';
import 'package:mediscript/widgets/text_widget.dart';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 6), () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LandingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //code para mawala to ang debug nga pula sa top right sa app screen
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCubeGrid(
              color: primary,
              size: 280.0,
            ),
            const SizedBox(
              height: 50,
            ),
            TextRegular(text: 'Loading...', fontSize: 12, color: primary)
          ],
        )),
      ),
    );
  }
}
