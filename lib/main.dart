import 'package:discoid/screens/home.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:discoid/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PlaylistService>(
          create: (_) => PlaylistService(),
        ),
        Provider<AudioPlayerService>(
          create: (_) => AudioPlayerService(),
          dispose: (_, audioPlayerService) {
            audioPlayerService.audioPlayer.dispose();
          },
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
