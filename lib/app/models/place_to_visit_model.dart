import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceToVisitModel {
  double lat;
  double long;
  String description;
  int createdAt;
  String imageUrl;
  String userId;

  PlaceToVisitModel(
      {required this.lat,
      required this.long,
      required this.createdAt,
      required this.description,
      required this.imageUrl,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
      'description': description,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }

  PlaceToVisitModel.fromMap(Map<String, dynamic> map)
      : lat = map['lat'],
        long = map['long'],
        description = map['description'],
        createdAt = map['createdAt'],
        imageUrl = map['imageUrl'],
        userId = map['userId'];
}
