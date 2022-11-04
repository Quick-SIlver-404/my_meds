import 'package:flutter/material.dart';
import 'dart:io';

import '../../widgets/mail_send_button.dart';
import '../../utilities/geoapify_api_caller.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final NearbyPharmaData pharmaData;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.pharmaData});

  @override
  Widget build(BuildContext context) {
    print('in pic screen ${pharmaData.name}');
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(imagePath)),
          MailSendButton(
            imagePath: imagePath,
            pharmaData: pharmaData,
          ),
        ],
      ),


    );
  }
}