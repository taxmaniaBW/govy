import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../consttants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool canCheckBiometrics;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    _checkBiometrics();
    if (canCheckBiometrics) {
      _getAvailableBiometrics();
    }
    super.initState();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(
            Icons.arrow_back,
            color: colorPrimary,
          ),
          title: Text(
            "Profile",
            style: TextStyle(
                fontFamily: 'Avenir',
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("App Security",
                  style: TextStyle(
                      fontFamily: 'Avenir',
                      color: colorPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () {
                  if (_availableBiometrics
                      .contains(BiometricType.fingerprint)) {
                    //
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              title: new Text("Error"),
                              content: new Text(
                                  "Your device does not have the required hardware for this feature"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Set up finger print lock",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: colorPrimary,
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Set up face detection lock",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: colorPrimary,
                      )),
                ),
              ),
            ),
          ],
        ),
      );
}
