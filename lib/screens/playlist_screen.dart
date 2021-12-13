import 'package:discoid/models/playlist.dart';
import 'package:discoid/screens/player_buttons.dart';
import 'package:discoid/screens/playlist_view.dart';
import 'package:discoid/screens/progress_bar_container.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist _playlist;

  const PlaylistScreen(this._playlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: PlaylistView(_playlist)),
              const PlayerButtons(),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: const ProgressBarContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
