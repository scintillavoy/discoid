import 'package:discoid/models/track.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(builder: (_, audioPlayerService, __) {
      return StreamBuilder(
        stream: audioPlayerService.audioPlayer.sequenceStateStream,
        builder: (_, snapshot) {
          Track? currentTrack =
              (snapshot.data as SequenceState?)?.currentSource?.tag;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentTrack != null && currentTrack.artwork != null
                  ? Image.memory(currentTrack.artwork!, width: 48)
                  : Icon(
                      Icons.music_note,
                      color: Theme.of(context).colorScheme.primary,
                      size: 48,
                    ),
              const SizedBox(width: 10),
              Text(
                currentTrack != null
                    ? "${currentTrack.title ?? currentTrack.uri}\n"
                        "${currentTrack.artist ?? "Unknown Artist"}"
                    : "Not Playing",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          );
        },
      );
    });
  }
}
