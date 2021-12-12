import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/position_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerService {
  final AudioPlayer audioPlayer = AudioPlayer();

  AudioPlayerService() {
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer.pause();
        audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices?.first);
      }
    });
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<Duration?> loadPlaylist(Playlist playlist) {
    return audioPlayer
        .setAudioSource(ConcatenatingAudioSource(
      children: playlist.items
          .map((playlistItem) => AudioSource.uri(
                playlistItem.uri,
                tag: playlistItem,
              ))
          .toList(),
    ))
        .catchError((error) {
      print("An error occured $error");
    });
  }
}
