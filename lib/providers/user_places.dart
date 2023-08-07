import 'dart:io';

import 'package:favorite_palces/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifire extends StateNotifier<List<Place>> {
  UserPlacesNotifire() : super(const []);

  void addPlace(String title,File image) {
    final newPlace = Place(title: title,image: image);

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifire, List<Place>>(
  (ref) => UserPlacesNotifire(),
);
