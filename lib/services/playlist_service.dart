import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/media.dart';

class PlaylistService {
  List<Playlist> playlists = [
    Playlist(
      name: "Dummy playlist",
      items: [
        Media(
          uri: "Dummy uri",
          title: "Dummy song",
          artist: "Dummy artist",
          album: "Dummy album",
          playCount: 0,
          skipCount: 0,
        ),
        Media(
          uri: "Dummy uri",
          title: "Dummy song",
          artist: "Dummy artist",
          album: "Dummy album",
          playCount: 0,
          skipCount: 0,
        ),
        Media(
          uri: "Dummy uri",
          title: "Dummy song",
          artist: "Dummy artist",
          album: "Dummy album",
          playCount: 0,
          skipCount: 0,
        ),
      ],
    ),
  ];

  List<Media> get allItems {
    return playlists.expand((playlist) => playlist.items).toList();
  }
}
