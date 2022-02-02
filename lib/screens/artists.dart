import 'package:discoid/screens/artist_screen.dart';
import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists>
    with AutomaticKeepAliveClientMixin<Artists> {
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
              children: mediaLibraryService.allArtists.map((artist) {
                return ListTile(
                  leading: artist.albums.isNotEmpty &&
                          artist.albums.first.tracks.isNotEmpty &&
                          artist.albums.first.tracks.first.artwork != null
                      ? Image.memory(
                          artist.albums.first.tracks.first.artwork!,
                          width: 48,
                        )
                      : Icon(
                          Icons.music_note,
                          color: Theme.of(context).colorScheme.primary,
                          size: 48,
                        ),
                  title: Text(artist.name ?? "Unknown Artist"),
                  subtitle: Text("${artist.albums.length}"),
                  onTap: () {
                    _navigatorKey.currentState?.push(MaterialPageRoute(
                      builder: (_) => ArtistScreen(artist),
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
