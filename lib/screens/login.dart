import 'dart:convert';
import 'dart:ui';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:govy/screens/main_screen.dart';
import 'package:govy/screens/registration_screen.dart';
import 'package:http/http.dart' as http;

import '../consttants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog _progressDialog = ProgressDialog();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color(0xff060B1F),
      backgroundColor: colorBackground,
      body: SizedBox.expand(
        child: Form(
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
                        borderSide: BorderSide(color: Colors.amber.shade100),
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
                        borderSide: BorderSide(color: Colors.amber.shade100),
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
}
