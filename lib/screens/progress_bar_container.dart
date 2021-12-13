import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:discoid/models/position_data.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressBarContainer extends StatelessWidget {
  const ProgressBarContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(builder: (_, audioPlayerService, __) {
      return StreamBuilder<PositionData>(
        stream: audioPlayerService.positionDataStream,
        builder: (_, snapshot) {
          final positionData = snapshot.data;
          return ProgressBar(
            progress: positionData?.position ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            buffered: positionData?.bufferedPosition ?? Duration.zero,
            onSeek: (duration) {
              audioPlayerService.audioPlayer.seek(duration);
            },
          );
        },
      );
    });
  }
}
