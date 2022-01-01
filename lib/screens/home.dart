import 'package:discoid/screens/import_button.dart';
import 'package:discoid/screens/media_library_screen.dart';
import 'package:discoid/screens/player_controller.dart';
import 'package:discoid/screens/playlists.dart';
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
              length: 2,
              child: Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('d_d'),
                    bottom: const TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Media Library"),
                        Tab(text: "Playlists"),
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    const MediaLibraryScreen(),
                    Playlists(),
                  ]),
                ),
              ),
            ),
            const ImportButton(),
            const PlayerController(),
          ],
        ),
      ),
    );
  }
}
