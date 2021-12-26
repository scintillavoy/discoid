import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/playlist_item.dart';

class PlaylistService {
  List<Playlist> playlists = [
    Playlist(name: "Dummy playlist", items: [
      PlaylistItem(
        title: "Dummy song",
        artist: "Dummy artist",
        album: "Dummy album",
        uri: Uri.parse("Dummy uri"),
      ),
    ]),
  ];

  List<PlaylistItem> get allItems {
    return playlists.expand((playlist) => playlist.items).toList();
  }
}
