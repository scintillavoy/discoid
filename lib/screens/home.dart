import 'package:discoid/screens/albums.dart';
import 'package:discoid/screens/autoplay_screen.dart';
import 'package:discoid/screens/tracks.dart';
import 'package:discoid/screens/playlists.dart';
import 'package:discoid/widgets/lyrics_panel.dart';
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
              length: 4,
              child: Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('d_d'),
                    bottom: const TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Autoplay"),
                        Tab(text: "Tracks"),
                        Tab(text: "Albums"),
                        Tab(text: "Playlists"),
                      ],
                    ),
                  ),
                  body: Row(
                    children: [
                      const SizedBox(
                        width: 550,
                        child: LyricsPanel(),
                      ),
                      VerticalDivider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      const Expanded(
                        child: TabBarView(children: [
                          AutoplayScreen(),
                          Tracks(),
                          Albums(),
                          Playlists(),
                        ]),
                      ),
                    ],
                  ),
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
