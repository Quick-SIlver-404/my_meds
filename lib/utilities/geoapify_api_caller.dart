import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:location/location.dart';

// import 'current_location.dart';

// For json parsing
import 'dart:convert';

class NearbyPharmaData {
  NearbyPharmaData({required this.latitude, required this.longitude, required this.name, required this.phoneNo});

  double latitude;
  double longitude;
  String name;
  String phoneNo;
}

Future<List<NearbyPharmaData>> retrievePharmaData(double longitude, double latitude, num limit, double distance) async {
  await dotenv.load(fileName: '.env');
  String? apiKey = dotenv.env['GEOAPIFY_API_KEY'];
  String? httpCall;
  http.Response? response;
  List<NearbyPharmaData> pharmaData = [];

  List<double> bounds = [];


  // print('in future: long $longitude, lat $latitude');

  bounds.add(longitude + distance);
  bounds.add(latitude + distance);
  bounds.add(longitude - distance);
  bounds.add(latitude - distance);

  String searchCategories = "healthcare.hospital,healthcare.pharmacy";

  if (apiKey != null) {
    httpCall = "https://api.geoapify.com/v2/places?categories=$searchCategories&filter=rect:${bounds[0]},${bounds[1]},${bounds[2]},${bounds[3]}&limit=$limit&apiKey=$apiKey";
  }

  if (httpCall != null) {
    response = await http.get(Uri.parse(httpCall));
    // print(response.body);
  }

  if (response != null) {
    pharmaData = parseJson(response.body);
  }
  // print (pharmaData.toString());
  return pharmaData;
}

List<NearbyPharmaData> parseJson(String responseBody) {
  List<NearbyPharmaData> pharmaData = [];
  final parsed = json.decode(responseBody)['features'].toList();

  parsed.forEach((dat) {
    final rawStr = dat['properties']['datasource']['raw'].toString();
    // print(rawStr);
    pharmaData.add(NearbyPharmaData(
        latitude: dat['properties']['lat'],
        longitude: dat['properties']['lon'],
        name: dat['properties']['name'],
        phoneNo: parsePhoneNoFromRawData(dat['properties']['datasource']['raw'].toString())
    ));
  });

  return pharmaData;
}

String parsePhoneNoFromRawData(String rawStr) {
  final rawsplit = rawStr.substring(1, rawStr.length - 1).split(',');
  for (var element in rawsplit) {
    // print(element);
    final spl = element.trim().split(' ');
    // print(spl);
    if (spl[0] == 'phone:' || spl[0] == 'contact:phone:') {
      return element.substring(spl[0].length + 1, element.length);
    }
  }
  return 'n/a';
}