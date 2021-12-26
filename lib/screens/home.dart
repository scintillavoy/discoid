import 'package:discoid/screens/player_controller.dart';
import 'package:discoid/screens/playlist_screen.dart';
import 'package:discoid/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<PlaylistService>(
                builder: (_, playlistService, __) {
                  return PlaylistScreen(playlistService.playlists[0]);
                },
              ),
            ),
            const SizedBox(
              height: 160,
              child: PlayerController(),
            ),
          ],
        ),
      ),
    );
  }
}
