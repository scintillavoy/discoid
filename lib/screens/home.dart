import 'package:discoid/screens/import_button.dart';
import 'package:discoid/screens/media_library_screen.dart';
import 'package:discoid/screens/player_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(child: MediaLibraryScreen()),
            ImportButton(),
            PlayerController(),
          ],
        ),
      ),
    );
  }
}
