import 'dart:async';

import 'package:http/http.dart' as http;

const String BASE_URL = "https://api.govapp.co.bw/";

class ApiHelper {
  Future login(userName, password) async {
    var url = BASE_URL + "api/auth/signin";
    var response = await http
        .post(url, body: {"username": userName, "password": password});
    return response;
  }
}

Future registerUser(userName, email, password) async {
  var url = BASE_URL + "api/auth/signup";
  var response = await http.post(url, body: {
    "username": userName,
    "password": password,
    "email": email,
    "role": "user"
  });
  return response;
}

Future submitCustomaryLandApplication() async {}
Future submitCommonLandApplication() async {}
Future submitVehicleRegistration() async {}
