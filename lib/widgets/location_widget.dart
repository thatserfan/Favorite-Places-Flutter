import 'dart:convert';

import 'package:favorite_palces/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LoactionInput extends StatefulWidget {
  const LoactionInput({super.key});

  @override
  State<LoactionInput> createState() {
    return _LoactionInputState();
  }
}

class _LoactionInputState extends State<LoactionInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.lat;
    final lng = _pickedLocation!.lng;
    return 'https://dev.virtualearth.net/REST/v1/Imagery/Map/Road/$lat,$lng/17?pp=$lat,$lng;37;&mapSize=600,300&key=AqzoIhkb99cryUre2QHyqdXEwblhBnBRPaI4rfTqwOucAtxFwxgt8kHVbeXhArrV';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    const keyapi =
        'AqzoIhkb99cryUre2QHyqdXEwblhBnBRPaI4rfTqwOucAtxFwxgt8kHVbeXhArrV';
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'http://dev.virtualearth.net/REST/v1/Locations/$lat,$lng?key=$keyapi');

    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['resourceSets'][0]['resources'][0]['address']
        ['formattedAddress'];

    setState(() {
      _pickedLocation = PlaceLocation(lat: lat, lng: lng, address: address);
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
