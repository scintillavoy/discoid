import 'package:discoid/services/media_library_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportButton extends StatelessWidget {
  const ImportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return ElevatedButton(
          child: const Text("Import"),
          onPressed: () async {
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(allowMultiple: true);
            if (result != null) {
              for (var file in result.files) {
                mediaLibraryService.addMediaByUri("file://${file.path}");
              }
            }
          },
        );
      },
    );
  }
}
