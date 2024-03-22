import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapui extends StatefulWidget {
  const mapui({super.key});

  @override
  State<mapui> createState() => _mapuiState();
}

class _mapuiState extends State<mapui> {
  static const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(34.882127, 35.888265),
    zoom: 14,
  );
  StreamSubscription<Position>? positionStream;
  List<Marker> markers = [];
  initialStream() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.whileInUse) {
      positionStream =
          Geolocator.getPositionStream().listen((Position? position) {
        markers.add(Marker(
            markerId: MarkerId("1"),
            position: LatLng(position!.latitude, position.longitude)));
        gmc!.animateCamera(CameraUpdate.newLatLng(
            LatLng(position!.latitude, position.longitude)));
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    initialStream();
    super.initState();
  }

  @override
  void dispose() {
    positionStream!.cancel();
    super.dispose();
  }

  GoogleMapController? gmc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAP'),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
              child: GoogleMap(
            onTap: (LatLng) {
              print('===========');
              print(LatLng.latitude);
              print(LatLng.longitude);
              print('===========');
              markers.add(Marker(markerId: MarkerId("1"), position: LatLng));
              setState(() {});
            },
            markers: markers.toSet(),
            initialCameraPosition: cameraPosition,
            mapType: MapType.normal,
            onMapCreated: (mapcontroller) {
              gmc = mapcontroller;
            },
          ))
        ],
      )),
    );
  }
}
