import 'dart:async';

import 'package:discoid/models/track.dart';
import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/position_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerService {
  final AudioPlayer audioPlayer = AudioPlayer();
  late StreamSubscription<PlayerState> playbackCompleteSubscription;
  Playlist? currentPlaylist;

  AudioPlayerService() {
    playbackCompleteSubscription =
        audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer.pause();
        audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices?.first);
      }
    });
  }

  void dispose() {
    playbackCompleteSubscription.cancel();
    audioPlayer.dispose();
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Track? get currentTrack {
    if (audioPlayer.currentIndex != null) {
      return currentPlaylist?.items[audioPlayer.currentIndex!];
    } else {
      return null;
    }
  }

  Future<Duration?> loadPlaylist(Playlist playlist) {
    if (currentPlaylist == playlist) {
      return Future<Duration?>.value(null);
    }
    currentPlaylist = playlist;
    return audioPlayer.setAudioSource(ConcatenatingAudioSource(
      children: playlist.items
          .map((track) => AudioSource.uri(
                Uri.parse(track.uri),
                tag: track,
              ))
          .toList(),
    ));
  }
}
