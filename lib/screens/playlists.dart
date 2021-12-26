import 'package:discoid/screens/playlist_screen.dart';
import 'package:discoid/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Playlists extends StatelessWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistService>(
      builder: (_, playlistService, __) {
        return ListView(
          children: playlistService.playlists.map((playlist) {
            return ListTile(
              title: Text(playlist.name),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PlaylistScreen(playlist),
                ));
              },
            );
          }).toList(),
        );
      },
    );
  }
}
