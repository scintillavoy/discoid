import 'package:discoid/widgets/now_playing.dart';
import 'package:discoid/widgets/player_buttons.dart';
import 'package:discoid/widgets/progress_bar_container.dart';
import 'package:flutter/material.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const NowPlaying(),
        ),
        const PlayerButtons(),
        Container(
          margin: const EdgeInsets.all(10),
          child: const ProgressBarContainer(),
        ),
      ],
    );
  }
}
