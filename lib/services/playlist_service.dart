import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/track.dart';

class PlaylistService {
  List<Playlist> playlists = [
    Playlist(
      name: "Dummy playlist",
      items: [
        Track(
          uri: "Dummy uri",
          title: "Dummy song",
          artist: "Dummy artist",
          album: "Dummy album",
          playCount: 0,
          skipCount: 0,
        ),
        Track(
          uri: "Dummy uri",
          title: "Dummy song",
          artist: "Dummy artist",
          album: "Dummy album",
          playCount: 0,
          skipCount: 0,
        ),
        Track(
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

  List<Track> get allItems {
    return playlists.expand((playlist) => playlist.items).toList();
  }
}
