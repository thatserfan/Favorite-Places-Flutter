import 'package:favorite_palces/screens/add_place_screen.dart';
import 'package:favorite_palces/widgets/places_list.dart';
import 'package:flutter/material.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddPlaceScreen(),
              ));
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Place',
          ),
        ],
      ),
      body: PlacesList(places: []),
    );
  }
}
