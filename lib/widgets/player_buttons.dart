import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(builder: (_, audioPlayerService, __) {
      final AudioPlayer audioPlayer = audioPlayerService.audioPlayer;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<bool>(
            stream: audioPlayerService.shuffleModeStream,
            builder: (context, snapshot) {
              return _shuffleButton(
                  context, snapshot.data ?? false, audioPlayerService);
            },
          ),
          StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (_, __) {
              return _previousButton(audioPlayerService);
            },
          ),
          StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (_, snapshot) {
              final playerState = snapshot.data;
              return _playPauseButton(playerState, audioPlayer);
            },
          ),
          StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (_, __) {
              return _nextButton(audioPlayerService);
            },
          ),
          StreamBuilder<LoopMode>(
            stream: audioPlayerService.loopModeStream,
            builder: (context, snapshot) {
              return _repeatButton(
                  context, snapshot.data ?? LoopMode.off, audioPlayerService);
            },
          ),
        ],
      );
    });
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled,
      AudioPlayerService audioPlayerService) {
    return IconButton(
      icon: isEnabled
          ? Icon(Icons.shuffle, color: Theme.of(context).colorScheme.secondary)
          : const Icon(Icons.shuffle),
      onPressed: () async {
        audioPlayerService.shuffleMode = !isEnabled;
      },
    );
  }

  Widget _previousButton(AudioPlayerService audioPlayerService) {
    return IconButton(
      icon: const Icon(Icons.skip_previous),
      onPressed: audioPlayerService.hasPrevious
          ? audioPlayerService.seekToPrevious
          : null,
    );
  }

  Widget _playPauseButton(PlayerState? playerState, AudioPlayer audioPlayer) {
    if (playerState?.playing != true) {
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: audioPlayer.play,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: audioPlayer.pause,
      );
    }
  }

  Widget _nextButton(AudioPlayerService audioPlayerService) {
    return Consumer<MediaLibraryService>(builder: (_, mediaLibraryService, __) {
      return IconButton(
        icon: const Icon(Icons.skip_next),
        onPressed: audioPlayerService.hasNext
            ? () async {
                if (audioPlayerService.currentTrack != null) {
                  await mediaLibraryService
                      .increaseSkipCount(audioPlayerService.currentTrack!);
                }
                audioPlayerService.seekToNext();
              }
            : null,
      );
    });
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode,
      AudioPlayerService audioPlayerService) {
    final icons = [
      const Icon(Icons.repeat),
      Icon(Icons.repeat, color: Theme.of(context).colorScheme.secondary),
      Icon(Icons.repeat_one, color: Theme.of(context).colorScheme.secondary),
    ];
    const loopModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = loopModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        audioPlayerService.loopMode =
            loopModes[(loopModes.indexOf(loopMode) + 1) % loopModes.length];
      },
    );
  }
}
