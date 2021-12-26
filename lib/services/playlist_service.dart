import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/media.dart';

class PlaylistService {
  List<Playlist> playlists = [
    Playlist(name: "Dummy playlist", items: [
      // Media(
      //   title: "Dummy song",
      //   artist: "Dummy artist",
      //   album: "Dummy album",
      //   uri: Uri.parse("Dummy uri"),
      // ),
    ]),
  ];

  List<Media> get allItems {
    return playlists.expand((playlist) => playlist.items).toList();
  }
}
