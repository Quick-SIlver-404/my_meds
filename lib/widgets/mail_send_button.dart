import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';

import '../utilities/current_location.dart';
import '../utilities/geoapify_api_caller.dart';
import '../utilities/position_to_map.dart';

class MailSendButton extends StatelessWidget {
  final NearbyPharmaData pharmaData;
  final String? imagePath;

  const MailSendButton({super.key, required this.imagePath, required this.pharmaData});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        LocationData? locationData = await getLocationData();

        var addresses = await placemarkFromCoordinates ((locationData?.latitude)!, (locationData?.longitude)!);
        var address = addresses.first;

        final Email sendEmail = Email(
          body: 'I am in ${address.locality}, ${address.street},${address.subLocality}, ${address.subAdministrativeArea} \n ${getMapLink((locationData?.latitude)!, (locationData?.longitude)!)}',
          subject: 'Need medicine at ${address.locality}',
          recipients: ['${pharmaData.name.replaceAll(' ', '').toLowerCase()}@gmail.com'],
          // cc: ['example_cc@ex.com'],
          // bcc: ['example_bcc@ex.com'],
          attachmentPaths: [imagePath!],
          isHTML: false,
        );

        await FlutterEmailSender.send(sendEmail);
      },
      child: const Icon(Icons.send),
    );
  }
}