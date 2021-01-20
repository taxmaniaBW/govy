import 'dart:convert';
import 'dart:ui';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:govy/screens/main_screen.dart';
import 'package:govy/screens/registration_screen.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consttants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog _progressDialog = ProgressDialog();
  final _formKey = GlobalKey<FormState>();

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];

  //TODO FIX FlutterActivity requirement
  bool _authorized = false;
  bool _isAuthenticating = false;
  Future<String> accessToken;
  @override
  void initState() {
    super.initState();
    getAccessToken().then((accessToken) {
      if (accessToken != null) {
        print("accessToken $accessToken");

        _getAvailableBiometrics().then((availableBiometrics) {
          print(availableBiometrics);

          setState(() {
            _availableBiometrics = availableBiometrics;
          });
          _authenticate().then((authenticated) {
            if (authenticated) {
              goToHomeScreen(context);
            }
          });
        });
      }
    });
  }

  Future<bool> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    return canCheckBiometrics;
  }

  Future<bool> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }

    return true;
  }

  Future<List<BiometricType>> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    return availableBiometrics;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color(0xff060B1F),
      backgroundColor: colorBackground,
      body: SizedBox.expand(
        child: _availableBiometrics.isNotEmpty &&
                _availableBiometrics.contains(BiometricType.fingerprint)
            ? biometricScanner()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Govy",
                      style: TextStyle(
                          fontSize: 72,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          color: colorPrimary),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: usernameController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.amber.shade100),
                              //  when the TextFormField in unfocused
                            ),
                            icon: Icon(
                              Icons.email,
                              color: colorPrimary,
                            ),
                            focusColor: Colors.amber,
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.amber.shade100),
                              //  when the TextFormField in unfocused
                            ),
                            icon: Icon(
                              Icons.lock_outline,
                              color: colorPrimary,
                            ),
                            focusColor: colorPrimary,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            login(context);
                          }
                        },
                        backgroundColor: colorPrimary,
                        child: Icon(
                          Icons.arrow_forward,
                          color: colorBackground,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return RegistrationScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(color: colorPrimary),
                                ))),
                        Expanded(
                            child: FlatButton(
                                onPressed: () {},
                                child: Text("Forgot Password",
                                    style: TextStyle(color: colorPrimary))))
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget biometricScanner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.fingerprint,
          size: 40,
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Scan finger print to continue",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        )
      ],
    );
  }

  login(context) async {
    _progressDialog.showProgressDialog(
      context,
      textToBeDisplayed: 'Signing In...',
    );
    var url = 'https://api.govapp.co.bw/api/auth/signin';
    var response = await http.post(url, body: {
      "username": usernameController.text,
      "password": passwordController.text
    });
    var parsedJson = json.decode(response.body);

    if (response.statusCode == 200) {
      _progressDialog.dismissProgressDialog(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Login Successful",
          style: TextStyle(fontFamily: 'Avenir'),
        ),
      ));
      saveToken(parsedJson['accessToken']).then((value) {
        goToHomeScreen(context);
      });
    } else {
      _progressDialog.dismissProgressDialog(context);
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Error"),
                content: new Text(parsedJson['message']),
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
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> saveToken(accessToken) async {
    final SharedPreferences prefs = await _prefs;
    final String _accessToken = "";

    setState(() {
      accessToken =
          prefs.setString("accessToken", accessToken).then((bool success) {
        return _accessToken;
      });
    });
  }

  Future<String> getAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("accessToken");
  }

  goToHomeScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MainScreen(
              // firstName: usernameController.text,
              );
        },
      ),
    );
  }
}
