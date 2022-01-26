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
        key: const PageStorageKey("PlaylistScreenListView"),
        controller: ScrollController(),
        itemExtent: 64,
        children: [
          for (int i = 0; i < _playlist.items.length; i++)
            ListTile(
              // selected: i == state.currentIndex,
              leading: _playlist.items.elementAt(i).artwork != null
                  ? Image.memory(
                      _playlist.items.elementAt(i).artwork!,
                      width: 48,
                    )
                  : Icon(
                      Icons.music_note,
                      color: Theme.of(context).colorScheme.primary,
                      size: 48,
                    ),
              title: Text(_playlist.items.elementAt(i).title),
              subtitle: Text(
                  "${_playlist.items.elementAt(i).artist} - ${_playlist.items.elementAt(i).album.name} - ${_playlist.items.elementAt(i).trackNumber} - ${_playlist.items.elementAt(i).discNumber} - ${_playlist.items.elementAt(i).playCount} - ${_playlist.items.elementAt(i).skipCount}"),
              onTap: () {
                final audioPlayerService =
                    Provider.of<AudioPlayerService>(context, listen: false);
                audioPlayerService.setPlaylist(_playlist);
                audioPlayerService
                    .seekToIndex(i, reshuffle: true)
                    .then((_) => audioPlayerService.audioPlayer.play());
              },
            ),
        ],
      ),
    );
  }
}
