import 'package:discoid/models/track.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class LyricsPanel extends StatelessWidget {
  const LyricsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(builder: (_, audioPlayerService, __) {
      return StreamBuilder(
        stream: audioPlayerService.audioPlayer.sequenceStateStream,
        builder: (_, snapshot) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                ((snapshot.data as SequenceState?)?.currentSource?.tag
                            as Track?)
                        ?.lyrics ??
                    "Lyrics not available.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      );
    });
  }
}
