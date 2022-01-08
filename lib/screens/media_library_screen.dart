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
                controller: ScrollController(),
                itemCount: allTracks.length,
                itemBuilder: (_, index) {
                  Track track = allTracks.elementAt(index);
                  return ListTile(
                    title: Text(track.title ?? "null"),
                    subtitle: Text(
                        "${track.artist ?? "null"} - ${track.album ?? "null"} - ${track.playCount} - ${track.skipCount}"),
                    onTap: () {
                      final audioPlayerService =
                          Provider.of<AudioPlayerService>(context,
                              listen: false);
                      audioPlayerService
                          .loadPlaylist(allTracksPlaylist)
                          .then((_) => audioPlayerService.audioPlayer
                              .seek(Duration.zero, index: index))
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
