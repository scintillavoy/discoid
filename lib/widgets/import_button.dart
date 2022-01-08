import 'dart:io';

import 'package:discoid/services/media_library_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportButton extends StatelessWidget {
  static const Set<String> allowedExtensions = {"mp3", "flac"};
  final bool isDirectoryImport;

  const ImportButton(this.isDirectoryImport, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return ElevatedButton(
          child: Text("Import ${isDirectoryImport ? "directory" : "files"}"),
          onPressed: () async {
            if (isDirectoryImport) {
              String? directoryPath =
                  await FilePicker.platform.getDirectoryPath();
              if (directoryPath == null) return;
              Directory directory = Directory(directoryPath);
              directory
                  .list(recursive: true, followLinks: false)
                  .forEach((file) {
                String path = Uri.decodeFull(file.uri.path.toString());
                if (FileSystemEntity.isDirectorySync(path)) return;
                if (!allowedExtensions.contains(path.split(".").last)) return;
                mediaLibraryService.addTrackByUri("file://$path");
              });
            } else {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);
              if (result == null) return;
              for (var file in result.files) {
                if (!allowedExtensions.contains(file.path?.split(".").last)) {
                  return;
                }
                mediaLibraryService.addTrackByUri("file://${file.path}");
              }
            }
          },
        );
      },
    );
  }
}
