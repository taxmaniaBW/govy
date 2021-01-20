import 'dart:convert';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:govy/consttants.dart';
import 'package:http/http.dart' as http;

class CustomaryLandScreen extends StatefulWidget {
  final bool citizen = false;
  final String gender = "";
  @override
  State<StatefulWidget> createState() => CustomaryLandState();
}

class CustomaryLandState extends State<CustomaryLandScreen> {
  ProgressDialog _progressDialog = ProgressDialog();
  String vehicleType = "";
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController postalAddress = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController nameOfPlace = TextEditingController();
  TextEditingController sizeOfPlot = TextEditingController();
  TextEditingController presentUse = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : submitApplication();
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() {
      currentStep = step;
    });
  }

  List<Step> steps = [
    Step(
        title: Text("Personal Details",
            style: TextStyle(color: colorPrimary, fontFamily: 'Avenir')),
        content: Container(
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Full Name",
                  ),
                ),
                TextFormField(
                    style: TextStyle(fontFamily: 'Avenir'),
                    decoration: InputDecoration(
                      hintText: "Postal Address",
                    )),
                TextFormField(
                    style: TextStyle(fontFamily: 'Avenir'),
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                    )),
                TextFormField(
                    style: TextStyle(fontFamily: 'Avenir'),
                    decoration: InputDecoration(
                      hintText: "Date Of Birth",
                    )),
                TextFormField(
                    style: TextStyle(fontFamily: 'Avenir'),
                    decoration: InputDecoration(
                      hintText: "Age",
                    )),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: const Text('Male',
                            style: TextStyle(fontFamily: 'Avenir')),
                        leading: Radio(
                          value: "Male",
                          groupValue: "",
                          onChanged: (String value) {},
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: const Text('Female',
                            style: TextStyle(fontFamily: 'Avenir')),
                        leading: Radio(
                          value: "Female",
                          groupValue: "",
                          onChanged: (String value) {},
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )),
    Step(
        title: Text("Plot Details",
            style: TextStyle(color: colorPrimary, fontFamily: 'Avenir')),
        content: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Name of Place",
                  ),
                ),
                TextFormField(
                    style: TextStyle(fontFamily: 'Avenir'),
                    decoration: InputDecoration(
                      hintText: "Present Use of the plot",
                    )),
                TextFormField(
                    style: TextStyle(fontFamily: 'Avenir'),
                    decoration: InputDecoration(
                      hintText: "Size of Plot",
                    )),
              ],
            ),
          ),
        )),
  ];

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
            "Customary Land Rights Application",
            style: TextStyle(
                fontFamily: 'Avenir',
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Stepper(
            type: StepperType.vertical,
            steps: steps,
            currentStep: currentStep,
            onStepContinue: next,
            onStepTapped: (step) => goTo(step),
            onStepCancel: cancel,
          ),
        ),
      );

  submitApplication() async {
    _progressDialog.showProgressDialog(
      context,
      textToBeDisplayed: 'Submitting Application...',
    );
    var url = 'https://api.govapp.co.bw/api/landapplication/new';
    var response = await http.post(url, headers: <String, String>{
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMDVhMWQyMDRkMWY1MzcxYjBhZjYwNSIsImlhdCI6MTYxMTA2NzgxNiwiZXhwIjoxNjExMTU0MjE2fQ.XkDuaBc6ef9JoynYgFOYqS2_hvO-XZKI5hHRHUHVzDg',
    }, body: {
      "fullNames": name.text,
      "postalAddress": postalAddress.text,
      "telNumber": phoneNumber.text,
      "age": age.text,
      "gender": "male",
    });
    var parsedJson = json.decode(response.body);

    if (response.statusCode == 200) {
      _progressDialog.dismissProgressDialog(context);
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Success"),
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
