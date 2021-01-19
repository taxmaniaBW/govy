import 'dart:convert';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../consttants.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VehicleRegistrationState();
}

class VehicleRegistrationState extends State<VehicleRegistrationScreen> {
  ProgressDialog _progressDialog = ProgressDialog();
  String vehicleType = "";
  TextEditingController make = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController bodyType = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController axels = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController postalAddress = TextEditingController();
  TextEditingController physicalAddress = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool citizen = false;
  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != steps.length ? goTo(currentStep + 1) : registerVehicle();
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
      title: Text(
        "Vehicle Type",
        style: TextStyle(color: colorPrimary, fontFamily: 'Avenir'),
      ),
      content: Container(
          margin: EdgeInsets.only(left: 12),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Brand New',
                    style: TextStyle(fontFamily: 'Avenir')),
                leading: Radio(
                  value: "Brand New",
                  groupValue: "",
                  onChanged: (String value) {},
                ),
              ),
              ListTile(
                title:
                    const Text('Used', style: TextStyle(fontFamily: 'Avenir')),
                leading: Radio(
                  value: "Used",
                  groupValue: "",
                  onChanged: (String value) {},
                ),
              ),
              ListTile(
                title: const Text('Rebuilt',
                    style: TextStyle(fontFamily: 'Avenir')),
                leading: Radio(
                  value: "Rebuilt",
                  groupValue: "",
                  onChanged: (String value) {},
                ),
              ),
            ],
          )
          // child: Text("Type Of Vehicle"),

          ),
    ),
    Step(
        title: Text("Owner Details",
            style: TextStyle(color: colorPrimary, fontFamily: 'Avenir')),
        content: Container(
          child: Column(
            children: <Widget>[
              TextField(
                style: TextStyle(fontFamily: 'Avenir'),
                decoration: InputDecoration(
                  hintText: "Full Name",
                ),
              ),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Postal Address",
                  )),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Physical Address",
                  )),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  )),
            ],
          ),
        )),
    Step(
        title: Text("Vehicle Details",
            style: TextStyle(color: colorPrimary, fontFamily: 'Avenir')),
        state: StepState.editing,
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                style: TextStyle(fontFamily: 'Avenir'),
                decoration: InputDecoration(
                  hintText: "Make",
                ),
              ),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Model",
                  )),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Body Type",
                  )),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Year of Manufacturer",
                  )),
              TextField(
                style: TextStyle(fontFamily: 'Avenir'),
                decoration: InputDecoration(
                  hintText: "Unladen Weight",
                ),
              ),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Gross Weight",
                  )),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Number of Axels",
                  )),
              TextField(
                  style: TextStyle(fontFamily: 'Avenir'),
                  decoration: InputDecoration(
                    hintText: "Color",
                  )),
            ],
          ),
        )),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(
            Icons.arrow_back,
            color: colorPrimary,
          ),
          title: Text(
            "Vehicle Registration",
            style: TextStyle(
                fontFamily: 'Avenir',
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              steps: steps,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
            ),
          ),
        ]),
//        body: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                "Owner Details",
//                style: TextStyle(
//                    color: colorPrimary, fontSize: 20, fontFamily: 'Avenir'),
//              ),
//            ),
//            Container(
//                margin: EdgeInsets.only(left: 12),
//                child: Column(
//                  children: <Widget>[
//                    ListTile(
//                      title: const Text('Brand New'),
//                      leading: Radio(
//                        value: "Brand New",
//                        groupValue: vehicleType,
//                        onChanged: (String value) {
//                          setState(() {
//                            vehicleType = value;
//                          });
//                        },
//                      ),
//                    ),
//                    ListTile(
//                      title: const Text('Used'),
//                      leading: Radio(
//                        value: "Used",
//                        groupValue: vehicleType,
//                        onChanged: (String value) {
//                          setState(() {
//                            vehicleType = value;
//                          });
//                        },
//                      ),
//                    ),
//                    ListTile(
//                      title: const Text('Rebuilt'),
//                      leading: Radio(
//                        value: "Rebuilt",
//                        groupValue: vehicleType,
//                        onChanged: (String value) {
//                          setState(() {
//                            vehicleType = value;
//                          });
//                        },
//                      ),
//                    ),
//                    CheckboxListTile(
//                      title: Text("Citizen"),
//                      onChanged: (bool value) {
//                        setState(() {
//                          citizen = value;
//                        });
//                      },
//                      value: citizen,
//                    )
//                  ],
//                )
//                // child: Text("Type Of Vehicle"),
//
//                )
//          ],
//        ),
      );

  ownerDetails() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Owner Details",
              style: TextStyle(
                  color: colorPrimary, fontSize: 20, fontFamily: 'Avenir'),
            ),
          ),
          TextField(
            style: TextStyle(fontFamily: 'Avenir'),
            decoration: InputDecoration(
              hintText: "Full Name",
            ),
          ),
          TextField(
              style: TextStyle(fontFamily: 'Avenir'),
              decoration: InputDecoration(
                hintText: "Postal Address",
              )),
          TextField(
              style: TextStyle(fontFamily: 'Avenir'),
              decoration: InputDecoration(
                hintText: "Physical Address",
              )),
          TextField(
              style: TextStyle(fontFamily: 'Avenir'),
              decoration: InputDecoration(
                hintText: "Phone Number",
              )),
        ],
      ),
    );
  }

  registerVehicle() async {
    _progressDialog.showProgressDialog(
      context,
      textToBeDisplayed: 'Registering Vehicle...',
    );

    var url = 'https://api.govapp.co.bw/api/vehicles/add';
    var response = await http.post(url, headers: <String, String>{
      'x-access-token':
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMDVhMWQyMDRkMWY1MzcxYjBhZjYwNSIsImlhdCI6MTYxMTA3Nzk5MSwiZXhwIjoxNjExMTY0MzkxfQ.LqnXeA_Ap4ki4fwzA_j7RFM-yUBweuZFfzLsIkdMxwo"
    }, body: {
      "name": fullName.text,
      "postalAddress": postalAddress.text,
      "physicalAddress": physicalAddress.text,
      "make": make.text,
      "model": model.text,
      "bodyType": bodyType.text,
      "unladdenWeight": weight.text,
      "yearManufactured": year.text,
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
