import 'package:discoid/models/media.dart';

class Playlist {
  String name;
  final List<Media> items;

  Playlist({required this.name, List<Media>? items}) : items = items ?? [];
}
