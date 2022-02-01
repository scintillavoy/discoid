import 'package:discoid/services/media_library_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportButton extends StatelessWidget {
  final bool isDirectoryImport;

  const ImportButton(this.isDirectoryImport, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaLibraryService>(
      builder: (_, mediaLibraryService, __) {
        return ElevatedButton(
          child: Text("Import ${isDirectoryImport ? "directory" : "files"}"),
          onPressed: () => mediaLibraryService.import(isDirectoryImport),
        );
      },
    );
  }
}
