import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView(this._audioPlayer, {Key? key}) : super(key: key);

  final AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: _audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final sequence = state.sequence;
        return ListView(
          children: [
            for (var i = 0; i < sequence.length; i++)
              ListTile(
                selected: i == state.currentIndex,
                title: Text(sequence[i].tag.title),
                subtitle: Text(
                    sequence[i].tag.artist + ' - ' + sequence[i].tag.album),
                onTap: () {
                  _audioPlayer.seek(Duration.zero, index: i);
                },
              ),
          ],
        );
      },
    );
  }
}
