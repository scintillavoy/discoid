import 'package:discoid/models/position_data.dart';
import 'package:discoid/screens/player_buttons.dart';
import 'package:discoid/screens/playlist_view.dart';
import 'package:discoid/screens/progress_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero,
            index: _audioPlayer.effectiveIndices?.first);
      }
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(children: [
            Expanded(child: PlaylistView(_audioPlayer)),
            PlayerButtons(_audioPlayer),
            StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (_, snapshot) {
                  return ProgressBarContainer(_audioPlayer, snapshot.data);
                }),
          ]),
        ),
      ),
    );
  }
}
