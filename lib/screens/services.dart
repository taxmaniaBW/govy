import 'package:flutter/material.dart';
import 'package:govy/screens/common_law_rights_screen.dart';
import 'package:govy/screens/customary_land_rights_screen.dart';
import 'package:govy/screens/vehicle_registration.dart';

import '../consttants.dart';

class ServicesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen> {
  List<String> services = [
    "Vehicle Registration",
    "Customary Law Land Rights",
    "Common Law Land Rights",
    "Plant Import Permit",
    "Internship",
    "Driving License",
    "Baits Access",
    "DVS_VMP",
  ];

  void goToService(index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VehicleRegistrationScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomaryLandScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CommonLandRightsScreen()));
    }
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
            "Services",
            style: TextStyle(
                fontFamily: 'Avenir',
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
            itemCount: services.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  onTap: () {
                    goToService(index);
                  },
                  trailing: Icon(Icons.arrow_forward_ios),
                  title: Text(services[index],
                      style: TextStyle(
                          color: colorPrimary, fontFamily: 'Avenir')));
            }),
      );
}
