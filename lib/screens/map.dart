import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

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
  var _latlong = const LatLng(0, 0);

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
      final pt1 = _mapController.latLngToScreenPoint(_latlong);
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

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    setState(() {
      _isGettingLocation = false;
      isMarkShow = true;
      _latlong = LatLng(lat, lng);
      _mapController.move(LatLng(lat, lng), 17);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.background,
        onPressed: _getCurrentLocation,
        child: _isGettingLocation
            ? const CircularProgressIndicator()
            : const Icon(Icons.location_on),
      ),
      appBar: AppBar(
        title: const Text('Pick Your Place Location'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(_latlong);
            },
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _latlong,
              maxZoom: 18,
              minZoom: 4,
              zoom: 6,
              onMapEvent: onMapEvent,
              onLongPress: (tapPos, latLng) {
                final pt1 = _mapController.latLngToScreenPoint(latLng);
                _textPos = Point(pt1.x, pt1.y);
                setState(() {
                  isMarkShow = true;
                  _latlong = latLng;
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
