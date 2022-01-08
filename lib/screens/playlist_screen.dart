import 'package:discoid/models/playlist.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist _playlist;

  const PlaylistScreen(this._playlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_playlist.name),
      ),
      body: ListView(
        controller: ScrollController(),
        children: [
          for (int i = 0; i < _playlist.items.length; i++)
            ListTile(
              // selected: i == state.currentIndex,
              title: Text(_playlist.items.elementAt(i).title ?? "null"),
              subtitle: Text(
                  "${_playlist.items.elementAt(i).artist ?? "null"} - ${_playlist.items.elementAt(i).album ?? "null"} - ${_playlist.items.elementAt(i).playCount} - ${_playlist.items.elementAt(i).skipCount}"),
              onTap: () {
                final audioPlayerService =
                    Provider.of<AudioPlayerService>(context, listen: false);
                audioPlayerService
                    .loadPlaylist(_playlist)
                    .then((_) => audioPlayerService.audioPlayer
                        .seek(Duration.zero, index: i))
                    .then((_) => audioPlayerService.audioPlayer.play());
              },
            ),
        ],
      ),
    );
  }
}
