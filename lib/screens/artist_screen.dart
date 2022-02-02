import 'package:discoid/models/artist.dart';
import 'package:discoid/models/playlist.dart';
import 'package:discoid/screens/playlist_screen.dart';
import 'package:flutter/material.dart';

class ArtistScreen extends StatelessWidget {
  final Artist _artist;

  const ArtistScreen(this._artist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_artist.name ?? "Unknown Artist")),
      body: ListView(
        controller: ScrollController(),
        itemExtent: 64,
        children: _artist.albums.map((album) {
          return ListTile(
            leading:
                album.tracks.isNotEmpty && album.tracks.first.artwork != null
                    ? Image.memory(
                        album.tracks.first.artwork!,
                        width: 48,
                      )
                    : Icon(
                        Icons.music_note,
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
            title: Text(album.name ?? "Unknown Album"),
            subtitle: Text(
                "${album.albumArtist.name ?? "Unknown Artist"} - ${album.tracks.length}"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PlaylistScreen(
                  Playlist(
                    name: album.name ?? "Unknown Album",
                    items: album.tracks,
                  ),
                ),
              ));
            },
          );
        }).toList(),
      ),
    );
  }
}
