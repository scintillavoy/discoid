import 'package:discoid/screens/albums.dart';
import 'package:discoid/screens/autoplay_screen.dart';
import 'package:discoid/screens/tracks.dart';
import 'package:discoid/screens/playlists.dart';
import 'package:discoid/widgets/lyrics_panel.dart';
import 'package:discoid/widgets/player_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  static const int mobileWidth = 850;

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                DefaultTabController(
                  length: constraints.maxWidth < mobileWidth ? 5 : 4,
                  child: Expanded(
                    child: Scaffold(
                      appBar: AppBar(
                        title: const Text('d_d'),
                        bottom: TabBar(
                          isScrollable: true,
                          tabs: [
                            const Tab(text: "Autoplay"),
                            const Tab(text: "Tracks"),
                            const Tab(text: "Albums"),
                            const Tab(text: "Playlists"),
                            if (constraints.maxWidth < mobileWidth)
                              const Tab(text: "Lyrics"),
                          ],
                        ),
                      ),
                      body: Row(
                        children: [
                          if (constraints.maxWidth >= mobileWidth) ...[
                            const SizedBox(
                              width: 550,
                              child: LyricsPanel(),
                            ),
                            VerticalDivider(
                              color: Theme.of(context).colorScheme.primary,
                              thickness: 1,
                            ),
                          ],
                          Expanded(
                            child: TabBarView(
                              children: [
                                const AutoplayScreen(),
                                const Tracks(),
                                const Albums(),
                                const Playlists(),
                                if (constraints.maxWidth < mobileWidth)
                                  Row(
                                    children: const [
                                      Expanded(
                                        child: LyricsPanel(),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
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
      },
    );
  }
}
