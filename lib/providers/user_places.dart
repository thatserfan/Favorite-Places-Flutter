import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:favorite_palces/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifire extends StateNotifier<List<Place>> {
  UserPlacesNotifire() : super(const []);

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    db.insert('user_places', {
      'id': newPlace.id,
      'title' : newPlace.title,
      'image' : newPlace.image.path,
      'lat' : newPlace.location.lat,
      'lng' : newPlace.location.lng,
      'address' : newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifire, List<Place>>(
  (ref) => UserPlacesNotifire(),
);
