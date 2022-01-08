import 'package:discoid/screens/playlist_screen.dart';
import 'package:discoid/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Playlists extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Playlists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistService>(
      builder: (_, playlistService, __) {
        return Navigator(
          key: _navigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => ListView(
              controller: ScrollController(),
              children: playlistService.playlists.map((playlist) {
                return ListTile(
                  title: Text(playlist.name),
                  onTap: () {
                    _navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (_) => PlaylistScreen(playlist),
                    ));
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
