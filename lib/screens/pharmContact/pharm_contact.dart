import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:my_meds/widgets/pharm_tile.dart';

import '../../utilities/geoapify_api_caller.dart';
import '../../utilities/current_location.dart';

class PharmContactScreen extends StatefulWidget {
  const PharmContactScreen({super.key});

  @override
  State<PharmContactScreen> createState() => _PharmContactScreenState();
}

class _PharmContactScreenState extends State<PharmContactScreen> {
  List<NearbyPharmaData> _nearbyPharmaData = [];
  double _differenceInDistance = 0.5;

  Future getPharmaData() async {
    LocationData? locationData = await getLocationData();
    if (locationData != null) {
      List<NearbyPharmaData> pharmaData = await retrievePharmaData(
          (locationData.longitude)!,
          (locationData.latitude)!,
          20,
          _differenceInDistance);
      setState(() {
        _nearbyPharmaData = pharmaData;
        print('setting pharma data with diff $_differenceInDistance');
      });
    }
  }

  double calculateToLatLong(double km) {
    int earthRadius = 6378;
    return km / earthRadius * 10 * 2 * 3.1415;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    getPharmaData();
    return Scaffold(
      appBar: AppBar(
        title:  Text('PharmaData'.tr),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.social_distance),
              hintText: 'Enter Distance of search',
              labelText: 'Distance'.tr,
            ),
            onChanged: (String? value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
              print('saved');
              if (value != null && isNumeric(value)) {
                print('isNumeric');
                setState(() {
                  _differenceInDistance =
                      calculateToLatLong(double.parse(value));
                });
                getPharmaData();
              }
            },
            // validator: (String? value) {
            //   return (value != null && value.contains('@'))
            //       ? 'Do not use the @ char.'
            //       : null;
            // },
          ),
          Expanded(child: SingleChildScrollView(child: Builder(
            builder: (context) {
              List<PharmTileData> texts = [];
              for (var dat in _nearbyPharmaData) {
                texts.add(PharmTileData(
                  pharmaData: dat,
                ));
              }

              return Column(
                children: texts,
              );
            },
          )))
        ],
      ),
    );
  }
}
