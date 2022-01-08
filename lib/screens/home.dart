import 'package:discoid/screens/autoplay_screen.dart';
import 'package:discoid/screens/media_library_screen.dart';
import 'package:discoid/screens/playlists.dart';
import 'package:discoid/widgets/player_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DefaultTabController(
              length: 3,
              child: Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('d_d'),
                    bottom: const TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Media Library"),
                        Tab(text: "Playlists"),
                        Tab(text: "Autoplay"),
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    const MediaLibraryScreen(),
                    Playlists(),
                    const AutoplayScreen(),
                  ]),
                ),
              ),
            ),
            const PlayerController(),
          ],
        ),
      ),
    );
  }
}
