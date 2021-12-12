import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/playlist_item.dart';

class PlaylistService {
  final List<Playlist> playlists = [];

  List<PlaylistItem> get allItems {
    return playlists.expand((playlist) => playlist.items).toList();
  }
}
