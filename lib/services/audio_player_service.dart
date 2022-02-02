import 'dart:async';

import 'package:discoid/models/track.dart';
import 'package:discoid/models/playlist.dart';
import 'package:discoid/models/position_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerService {
  final AudioPlayer audioPlayer = AudioPlayer();
  late StreamSubscription<ProcessingState> processingStateStreamSubscription;
  Playlist? currentPlaylist;
  int? currentIndex;
  List<int>? _shuffledIndices;
  LoopMode _loopMode = LoopMode.off;
  bool _shuffleMode = false;

  AudioPlayerService() {
    audioPlayer.setVolume(0.35);
    processingStateStreamSubscription =
        audioPlayer.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        if (hasNext) {
          if (_loopMode != LoopMode.one) {
            currentIndex = nextIndex;
          }
          await seekToIndex(currentIndex!);
        } else {
          await audioPlayer.pause();
          await seekToIndex(0);
        }
      }
    });
  }

  void dispose() {
    processingStateStreamSubscription.cancel();
    audioPlayer.dispose();
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<LoopMode> get loopModeStream =>
      audioPlayer.loopModeStream.map((_) => _loopMode);

  set loopMode(LoopMode loopMode) {
    _loopMode = loopMode;
    audioPlayer.setLoopMode(LoopMode.off);
  }

  Stream<bool> get shuffleModeStream =>
      audioPlayer.shuffleModeEnabledStream.map((_) => _shuffleMode);

  set shuffleMode(bool shuffleMode) {
    if (_shuffleMode == shuffleMode) return;
    _shuffleMode = shuffleMode;
    audioPlayer.setShuffleModeEnabled(shuffleMode);
    if (shuffleMode) {
      shuffle(currentIndex);
    } else {
      if (currentIndex != null) {
        currentIndex = _shuffledIndices?[currentIndex!];
      }
      _shuffledIndices = null;
    }
  }

  bool shuffle(int? startIndex) {
    if (currentPlaylist == null) return false;
    List<int> shuffledIndices = List<int>.generate(
      currentPlaylist?.items.length ?? 0,
      (index) => index,
    );
    shuffledIndices.shuffle();
    if (startIndex != null) {
      shuffledIndices.remove(startIndex);
      shuffledIndices.insert(0, startIndex);
      currentIndex = 0;
    }
    _shuffledIndices = shuffledIndices;
    return true;
  }

  Track? get currentTrack => audioPlayer.sequenceState?.currentSource?.tag;

  int? get nextIndex {
    switch (_loopMode) {
      case LoopMode.off:
        return currentIndex != null &&
                currentIndex! + 1 < (currentPlaylist?.items.length ?? 0)
            ? currentIndex! + 1
            : null;
      case LoopMode.one:
      case LoopMode.all:
        return currentIndex != null && currentPlaylist != null
            ? (currentIndex! + 1) % currentPlaylist!.items.length
            : null;
    }
  }

  int? get previousIndex {
    switch (_loopMode) {
      case LoopMode.off:
        return currentIndex != null && currentIndex! - 1 >= 0
            ? currentIndex! - 1
            : null;
      case LoopMode.one:
      case LoopMode.all:
        return currentIndex != null && currentPlaylist != null
            ? (currentIndex! - 1) % currentPlaylist!.items.length
            : null;
    }
  }

  bool get hasNext => nextIndex != null;

  bool get hasPrevious => previousIndex != null;

  Future<Duration?> seekToNext() {
    if (hasNext) {
      return seekToIndex(nextIndex!);
    } else {
      return Future<Duration?>.value(null);
    }
  }

  Future<Duration?> seekToPrevious() {
    if (hasPrevious) {
      return seekToIndex(previousIndex!);
    } else {
      return Future<Duration?>.value(null);
    }
  }

  Future<Duration?> seekToIndex(int index, {bool reshuffle = false}) {
    if (index < 0 || index >= (currentPlaylist?.items.length ?? 0)) {
      return Future<Duration?>.value(null);
    }
    if (_shuffleMode && reshuffle) {
      shuffle(index);
      index = 0;
    } else {
      currentIndex = index;
    }
    index = _shuffleMode ? _shuffledIndices![index] : index;
    return audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(currentPlaylist!.items.elementAt(index).uri),
      tag: currentPlaylist!.items.elementAt(index),
    ));
  }

  bool setPlaylist(Playlist playlist) {
    if (currentPlaylist == playlist) {
      return false;
    }
    currentPlaylist = playlist;
    currentIndex = null;
    return true;
  }
}
