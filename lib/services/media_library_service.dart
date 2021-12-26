import 'package:discoid/models/media.dart';
import 'package:flutter/material.dart';

class MediaLibraryService extends ChangeNotifier {
  Map<Uri, Media> mediaLibrary = <Uri, Media>{};

  void addMedia(final Media media) {
    mediaLibrary[media.uri] = media;
    notifyListeners();
  }
}
