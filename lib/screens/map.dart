import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is! MapEventMove && mapEvent is! MapEventRotate) {
      // do not flood console with move and rotate events
      // debug(mapEvent.center.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var latlong = const LatLng(31.994335, 54.269765);

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.location_on),
          ),
          appBar: AppBar(
            title: const Text('Pick Your Place Location'),
          ),
          body: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: const LatLng(31.994335, 54.269765),
              zoom: 6,
              onMapEvent: onMapEvent,
              onLongPress: (tapPos, latLng) {
                final pt1 = _mapController.latLngToScreenPoint(latLng);
                _textPos = Point(pt1.x, pt1.y);
                setState(() {
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
        ),
        Positioned(
          left: _textPos.x.toDouble() - 22,
          top: _textPos.y.toDouble() + 60,
          width: 20,
          height: 20,
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 50,
          ),
        )
      ],
    );
  }
}
