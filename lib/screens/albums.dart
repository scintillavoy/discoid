import 'package:discoid/models/playlist.dart';
import 'package:discoid/screens/playlist_screen.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Albums extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Albums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return Navigator(
          key: _navigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => ListView(
              key: const PageStorageKey("AlbumsListView"),
              controller: ScrollController(),
              itemExtent: 64,
              children: mediaLibraryService.allAlbums.map((album) {
                return ListTile(
                  leading: album.tracks.isNotEmpty &&
                          album.tracks.first.artwork != null
                      ? Image.memory(
                          album.tracks.first.artwork!,
                          width: 48,
                        )
                      : Icon(
                          Icons.music_note,
                          color: Theme.of(context).colorScheme.primary,
                          size: 48,
                        ),
                  title: Text(album.name ?? "Unknown Album"),
                  subtitle: Text(
                      "${album.albumArtist ?? "Unknown Artist"} - ${album.tracks.length}"),
                  onTap: () {
                    _navigatorKey.currentState?.push(MaterialPageRoute(
                      builder: (_) => PlaylistScreen(
                        Playlist(
                          name: album.name ?? "Unknown Album",
                          items: album.tracks,
                        ),
                      ),
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
