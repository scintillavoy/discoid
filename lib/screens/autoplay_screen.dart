import 'dart:collection';

import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/track.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:discoid/widgets/autoplay_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutoplayScreen extends StatelessWidget {
  const AutoplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        SplayTreeSet<Track> autoplayTracks = mediaLibraryService.autoplayTracks;
        Playlist autoplayTracksPlaylist =
            Playlist(name: 'autoplayTracks', items: autoplayTracks);
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: autoplayTracks.length,
                itemBuilder: (_, index) {
                  Track track = autoplayTracks.elementAt(index);
                  return ListTile(
                    title: Text(track.title ?? "null"),
                    subtitle: Text(
                        "${track.artist ?? "null"} - ${track.album ?? "null"} - ${track.playCount} - ${track.skipCount}"),
                    onTap: () {
                      final audioPlayerService =
                          Provider.of<AudioPlayerService>(context,
                              listen: false);
                      audioPlayerService
                          .loadPlaylist(autoplayTracksPlaylist)
                          .then((_) => audioPlayerService.audioPlayer
                              .seek(Duration.zero, index: index))
                          .then((_) => audioPlayerService.audioPlayer.play());
                    },
                  );
                },
              ),
            ),
            const AutoplayButton(),
          ],
        );
      },
    );
  }
}
