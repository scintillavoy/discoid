import 'dart:collection';

import 'package:discoid/models/track.dart';
import 'package:discoid/models/playlist.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:discoid/widgets/import_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaLibraryScreen extends StatelessWidget {
  const MediaLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        SplayTreeSet<Track> allTracks = mediaLibraryService.allTracks;
        Playlist allTracksPlaylist =
            Playlist(name: 'allTracks', items: allTracks);
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                key: const PageStorageKey("MediaLibraryScreenListView"),
                controller: ScrollController(),
                itemCount: allTracks.length,
                itemExtent: 64,
                itemBuilder: (_, index) {
                  Track track = allTracks.elementAt(index);
                  return ListTile(
                    leading: track.artwork != null
                        ? Image.memory(
                            track.artwork!,
                            width: 48,
                          )
                        : Icon(
                            Icons.music_note,
                            color: Theme.of(context).colorScheme.primary,
                            size: 48,
                          ),
                    title: Text("${track.title}"),
                    subtitle: Text(
                        "${track.artist} - ${track.album} - ${track.trackNumber} - ${track.discNumber} - ${track.playCount} - ${track.skipCount}"),
                    onTap: () {
                      final audioPlayerService =
                          Provider.of<AudioPlayerService>(context,
                              listen: false);
                      audioPlayerService.setPlaylist(allTracksPlaylist);
                      audioPlayerService
                          .seekToIndex(index, reshuffle: true)
                          .then((_) => audioPlayerService.audioPlayer.play());
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: const ImportButton(false),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: const ImportButton(true),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
