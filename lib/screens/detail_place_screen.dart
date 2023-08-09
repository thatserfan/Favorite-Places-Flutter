import 'package:favorite_palces/models/place.dart';
import 'package:flutter/material.dart';

class DetailPlaceScreen extends StatelessWidget {
  const DetailPlaceScreen({super.key, required this.place});

  final Place place;

   String get locationImage {

    final lat = place.location.lat;
    final lng = place.location.lng;
    return 'https://dev.virtualearth.net/REST/v1/Imagery/Map/Road/$lat,$lng/17?pp=$lat,$lng;37;&mapSize=600,300&key=AqzoIhkb99cryUre2QHyqdXEwblhBnBRPaI4rfTqwOucAtxFwxgt8kHVbeXhArrV';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(locationImage),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
