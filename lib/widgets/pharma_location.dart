// Library Import
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Local Import
import '../utilities/geoapify_api_caller.dart';

Marker createMarker(NearbyPharmaData pharmadata) {
  print('creating marker for ${pharmadata.name}');
  return Marker(
      point: LatLng(
          pharmadata.latitude, pharmadata.longitude
      ),
      builder:  (buildContext) {
        print('Displaying at ${pharmadata.latitude}, ${pharmadata.longitude}');
        return  const Icon(Icons.local_hospital, color: Colors.blue,);
      }
  );
}

class PharmaLocation extends StatelessWidget {
  const PharmaLocation({super.key});

  @override
  Widget build(BuildContext context) {
    print('object');
    return const Icon(Icons.local_hospital, color: Colors.blue,);
  }
}

// class PharmaLocation extends StatefulWidget {
//   NearbyPharmaData pharmadata;
//
//   PharmaLocation({super.key, required this.pharmadata});
//
//   @override
//   State<PharmaLocation> createState() => _PharmaLocationWidget();
// }
//
// class _PharmaLocationWidget extends State<PharmaLocation> {
//   @override
//   Widget build(BuildContext context) {
//     return const Icon(Icons.local_hospital, color: Colors.red,);
//   }
// }