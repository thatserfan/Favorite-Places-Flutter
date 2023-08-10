import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  late final MapController _mapController;

  Point<double> _textPos = const Point(10, 10);
  var latlong = const LatLng(31.994335, 54.269765);

  bool isMarkShow = false;
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is MapEventMove ||
        mapEvent is MapEventRotate ||
        mapEvent is MapEventDoubleTapZoom) {
      // do not flood console with move and rotate events
      // debug(mapEvent.center.toString());
      final pt1 = _mapController.latLngToScreenPoint(latlong);
      _textPos = Point(pt1.x, pt1.y);
      setState(() {});
    }
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
      _isGettingLocation = false;
      isMarkShow = true;
      latlong = LatLng(lat, lng);
      _mapController.move(LatLng(lat, lng), 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.background,
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.location_on),
      ),
      appBar: AppBar(
        title: const Text('Pick Your Place Location'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: latlong,
              zoom: 6,
              onMapEvent: onMapEvent,
              onLongPress: (tapPos, latLng) {
                final pt1 = _mapController.latLngToScreenPoint(latLng);
                _textPos = Point(pt1.x, pt1.y);
                setState(() {
                  print(latLng);
                  isMarkShow = true;
                  latlong = latLng;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
            ],
          ),
          Positioned(
            left: _textPos.x.toDouble() - 22,
            top: _textPos.y.toDouble() - 40,
            width: 20,
            height: 20,
            child: Icon(
              Icons.location_on,
              color: isMarkShow ? Colors.red : Colors.transparent,
              size: 50,
            ),
          )
        ],
      ),
    );
  }
}
