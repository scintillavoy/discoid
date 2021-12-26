import 'package:discoid/models/media.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class MediaLibraryService extends ChangeNotifier {
  Map<String, Media> mediaLibrary = <String, Media>{};
  late Future<Database> database;
  var store = stringMapStoreFactory.store('media');

  MediaLibraryService() {
    database = () async {
      Database db = await databaseFactoryIo.openDatabase('sample.db');
      return db;
    }();
    () async {
      Database db = await database;
      var results = await store.find(db);
      for (var result in results) {
        Map<String, dynamic> media = result.value;
        mediaLibrary[media['uri']] = Media.fromMap(media);
      }
      notifyListeners();
    }();
  }

  void addMedia(final Media media) async {
    mediaLibrary[media.uri] = media;
    notifyListeners();
    Database db = await database;
    await store.record(media.uri).put(db, media.toMap());
  }
}
