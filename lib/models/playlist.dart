import 'package:discoid/models/track.dart';

class Playlist {
  String name;
  Iterable<Track> items;

  Playlist({required this.name, required this.items});
}
