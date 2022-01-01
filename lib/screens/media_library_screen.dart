import 'package:discoid/models/track.dart';
import 'package:discoid/models/playlist.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaLibraryScreen extends StatelessWidget {
  const MediaLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        Map<String, Track> allTracks = mediaLibraryService.allTracks;
        return ListView.builder(
          itemCount: allTracks.length,
          itemBuilder: (_, index) {
            String key = allTracks.keys.elementAt(index);
            Track value = allTracks[key]!;
            return ListTile(
              title: Text(value.title ?? "null"),
              subtitle: Text(
                  "${value.artist ?? "null"} - ${value.album ?? "null"} - ${value.playCount} - ${value.skipCount}"),
              onTap: () {
                final audioPlayerService =
                    Provider.of<AudioPlayerService>(context, listen: false);
                audioPlayerService
                    .loadPlaylist(Playlist(
                      name: 'allTracks',
                      // TODO: convert to List only when necessary
                      items: allTracks.values.toList(),
                    ))
                    .then((_) => audioPlayerService.audioPlayer
                        .seek(Duration.zero, index: index))
                    .then((_) => audioPlayerService.audioPlayer.play());
              },
            );
          },
        );
      },
    );
  }
}
