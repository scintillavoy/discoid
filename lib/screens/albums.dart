import 'package:discoid/models/playlist.dart';
import 'package:discoid/screens/playlist_screen.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums>
    with AutomaticKeepAliveClientMixin<Albums> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return Navigator(
          key: _navigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => ListView(
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
