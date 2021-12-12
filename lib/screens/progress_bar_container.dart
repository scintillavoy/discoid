import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:discoid/models/position_data.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ProgressBarContainer extends StatelessWidget {
  const ProgressBarContainer(this._audioPlayer, this._positionData, {Key? key})
      : super(key: key);

  final AudioPlayer _audioPlayer;
  final PositionData? _positionData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ProgressBar(
        progress: _positionData?.position ?? Duration.zero,
        total: _positionData?.duration ?? Duration.zero,
        buffered: _positionData?.bufferedPosition ?? Duration.zero,
        onSeek: (duration) {
          _audioPlayer.seek(duration);
        },
      ),
    );
  }
}
