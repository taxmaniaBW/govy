import 'dart:convert';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:govy/consttants.dart';
import 'package:govy/screens/login.dart';
import 'package:govy/screens/main_screen.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  ProgressDialog _progressDialog = ProgressDialog();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color(0xff060B1F),
      backgroundColor: colorBackground,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: true,
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
                    style: TextStyle(color: Colors.white, fontFamily: 'Avenir'),
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
                        return 'Please enter email';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white, fontFamily: 'Avenir'),
                    controller: emailController,
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
                        hintText: "Email",
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
                    style: TextStyle(color: Colors.white, fontFamily: 'Avenir'),
                    obscureText: true,
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
                        register(context);
                      }

//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) {
//                        return register();
//                      },
//                    ),
//                  );
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
                                    return Login();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Login",
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
      ),
    );
  }

  register(context) async {
    _progressDialog.showProgressDialog(
      context,
      textToBeDisplayed: 'Registering...',
    );
    var url = 'https://api.govapp.co.bw/api/auth/signup';
    var response = await http.post(url, body: {
      "username": usernameController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "role": "user"
    });
    var parsedJson = json.decode(response.body);
    print(parsedJson);
    if (response.statusCode == 200) {
      _progressDialog.dismissProgressDialog(context);
      final snackBar = SnackBar(
        content: Text(
          "Login Successful",
          style: TextStyle(fontFamily: 'Avenir'),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainScreen(
              fullName: usernameController.text,
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
    print(response);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
