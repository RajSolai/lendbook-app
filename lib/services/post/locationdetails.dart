import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetails extends StatefulWidget {
  final address, latitude, longitude;
  LocationDetails(
      {Key key,
      @required this.address,
      @required this.latitude,
      @required this.longitude});

  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(
              this.widget.latitude as double, this.widget.longitude as double)),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ));
  }
}
