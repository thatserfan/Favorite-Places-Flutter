import 'package:flutter/material.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() {
    return PlacesScreenState();
  }
}

class PlacesScreenState extends State<PlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            tooltip: 'Add Place',
          ),
        ],
      ),
    );
  }
}
