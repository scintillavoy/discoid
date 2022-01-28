import 'package:discoid/screens/playlist_screen.dart';
import 'package:discoid/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists>
    with AutomaticKeepAliveClientMixin<Playlists> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PlaylistService>(
      builder: (_, playlistService, __) {
        return Navigator(
          key: _navigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => ListView(
              controller: ScrollController(),
              itemExtent: 64,
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
