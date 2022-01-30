import 'package:discoid/models/playlist.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutoplayButton extends StatelessWidget {
  const AutoplayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return ElevatedButton(
          onPressed: () {
            mediaLibraryService.generateAutoplayTracks();
            final audioPlayerService =
                Provider.of<AudioPlayerService>(context, listen: false);
            audioPlayerService.setPlaylist(Playlist(
              name: 'autoplayTracks',
              items: mediaLibraryService.autoplayTracks,
            ));
            audioPlayerService
                .seekToIndex(0, reshuffle: true)
                .then((_) => audioPlayerService.audioPlayer.play());
          },
          child: const Text("Autoplay"),
        );
      },
    );
  }
}
