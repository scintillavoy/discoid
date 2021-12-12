import 'package:discoid/models/playlist_item.dart';

class Playlist {
  String name;
  final List<PlaylistItem> items;

  Playlist({required this.name, List<PlaylistItem>? items})
      : items = items ?? [];
}
