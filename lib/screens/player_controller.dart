import 'package:discoid/screens/player_buttons.dart';
import 'package:discoid/screens/progress_bar_container.dart';
import 'package:flutter/material.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const PlayerButtons(),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: const ProgressBarContainer(),
        ),
      ],
    );
  }
}
