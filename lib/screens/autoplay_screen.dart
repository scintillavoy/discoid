import 'dart:collection';

import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/track.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:discoid/widgets/autoplay_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutoplayScreen extends StatefulWidget {
  const AutoplayScreen({Key? key}) : super(key: key);

  @override
  _AutoplayScreenState createState() => _AutoplayScreenState();
}

class _AutoplayScreenState extends State<AutoplayScreen>
    with AutomaticKeepAliveClientMixin<AutoplayScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        SplayTreeSet<Track> autoplayTracks = mediaLibraryService.autoplayTracks;
        Playlist autoplayTracksPlaylist =
            Playlist(name: 'autoplayTracks', items: autoplayTracks);
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: ScrollController(),
                itemCount: autoplayTracks.length,
                itemExtent: 64,
                itemBuilder: (_, index) {
                  Track track = autoplayTracks.elementAt(index);
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
                    title: Text(track.title),
                    subtitle: Text(
                        "${track.artist} - ${track.album.name} - ${track.trackNumber} - ${track.discNumber} - ${track.playCount} - ${track.skipCount}"),
                    onTap: () {
                      final audioPlayerService =
                          Provider.of<AudioPlayerService>(context,
                              listen: false);
                      audioPlayerService.setPlaylist(autoplayTracksPlaylist);
                      audioPlayerService
                          .seekToIndex(index, reshuffle: true)
                          .then((_) => audioPlayerService.audioPlayer.play());
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: const AutoplayButton(),
            ),
          ],
        );
      },
    );
  }
}
