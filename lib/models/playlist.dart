import 'package:discoid/models/track.dart';

class Playlist {
  String name;
  final List<Track> items;

  Playlist({required this.name, List<Track>? items}) : items = items ?? [];
}
