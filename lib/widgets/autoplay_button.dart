import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutoplayButton extends StatelessWidget {
  const AutoplayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return ElevatedButton(
          onPressed: () {
            mediaLibraryService.generateAutoplayTracks();
          },
          child: const Text("Autoplay"),
        );
      },
    );
  }
}
