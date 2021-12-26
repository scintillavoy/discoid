import 'package:discoid/screens/player_buttons.dart';
import 'package:discoid/screens/progress_bar_container.dart';
import 'package:flutter/material.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: PlayerButtons()),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: const ProgressBarContainer(),
          ),
        ],
      ),
    );
  }
}
