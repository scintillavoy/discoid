import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:discoid/models/position_data.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressBarContainer extends StatelessWidget {
  final PositionData? _positionData;

  const ProgressBarContainer(this._positionData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Consumer<AudioPlayerService>(
        builder: (_, audioPlayerService, __) {
          return ProgressBar(
            progress: _positionData?.position ?? Duration.zero,
            total: _positionData?.duration ?? Duration.zero,
            buffered: _positionData?.bufferedPosition ?? Duration.zero,
            onSeek: (duration) {
              audioPlayerService.audioPlayer.seek(duration);
            },
          );
        },
      ),
    );
  }
}
