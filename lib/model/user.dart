import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String id;
  String name;
  LatLng pos;
  String picLink;

  User(this.id, this.name, this.pos, this.picLink);
}
