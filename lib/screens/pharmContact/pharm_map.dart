import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utilities/geoapify_api_caller.dart';
import '../../utilities/position_to_map.dart';

class PharmMap extends StatefulWidget {
  final NearbyPharmaData pharmaData;

  PharmMap({super.key, required this.pharmaData});



  @override
  State<PharmMap> createState() => _PharmMapState();
}

class _PharmMapState extends State<PharmMap> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text(widget.pharmaData.name),
    ),
      body: WebView(
      initialUrl: getMapLink(widget.pharmaData.latitude, widget.pharmaData.longitude),
      javascriptMode: JavascriptMode.unrestricted,
    ),
    );
  }
}