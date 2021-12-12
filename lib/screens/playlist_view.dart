import 'package:discoid/models/playlist.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistView extends StatelessWidget {
  final Playlist _playlist;

  const PlaylistView(this._playlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < _playlist.items.length; i++)
          ListTile(
            // selected: i == state.currentIndex,
            title: Text(_playlist.items[i].title),
            subtitle: Text(
                _playlist.items[i].artist + ' - ' + _playlist.items[i].album),
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
    );
  }
}
