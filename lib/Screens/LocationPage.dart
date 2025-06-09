import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  final String title;
  const LocationPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }

  Future<Map<String, double>?> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (error) {
      return null;
    }
  }
}

class _LocationPageState extends State<LocationPage> {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> setLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      }
    }

    Map<String, double>? location = await widget.getLocation();

    if (location != null) {
      setState(() {
        latitude = location['latitude']!;
        longitude = location['longitude']!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Text('Lat: $latitude, Lon: $longitude'),
      ),
    );
  }
}