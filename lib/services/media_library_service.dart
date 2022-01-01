import 'dart:async';
import 'dart:io';

import 'package:discoid/models/media.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:id3tag/id3tag.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/timestamp.dart';

class MediaLibraryService extends ChangeNotifier {
  StreamSubscription<Duration>? increasePlayCountSubscription;
  Map<String, Media> mediaLibrary = <String, Media>{};
  late Future<Database> database;
  var fileStore = stringMapStoreFactory.store('file');
  var mediaStore = intMapStoreFactory.store('media');

  MediaLibraryService() {
    database = () async {
      Database db = await databaseFactoryIo.openDatabase('sample.db');
      return db;
    }();
    () async {
      Database db = await database;

      var fileMaps = await fileStore.find(db);

      for (var fileMap in fileMaps) {
        ID3Tag tag;
        try {
          tag = ID3TagReader.path(Uri.decodeFull(Uri.parse(fileMap.key).path))
              .readTagSync();
        } on FileSystemException {
          print("MediaLibraryService(): File not found");
          continue;
        }

        Media media = Media(
          uri: fileMap.key,
          title: tag.title ?? fileMap.key.split('/').last,
          artist: tag.artist,
          album: tag.album,
          trackNumber: tag.track,
          playCount: fileMap.value['playCount'] as int,
          skipCount: fileMap.value['skipCount'] as int,
          lastPlayedTimestamp:
              fileMap.value['lastPlayedTimestamp'] as Timestamp?,
          lastSkippedTimestamp:
              fileMap.value['lastSkippedTimestamp'] as Timestamp?,
        );

        await syncStores(media);
        mediaLibrary[fileMap.key] = media;
      }
      notifyListeners();
    }();
  }

  @override
  void dispose() {
    increasePlayCountSubscription?.cancel();
    super.dispose();
  }

  void update(final AudioPlayerService audioPlayerService) {
    print("MediaLibraryService updated");
    final AudioPlayer audioPlayer = audioPlayerService.audioPlayer;
    increasePlayCountSubscription?.cancel();
    increasePlayCountSubscription =
        audioPlayer.positionStream.listen((position) {
      if (audioPlayer.duration != null &&
          position > audioPlayer.duration! ~/ 5 &&
          audioPlayer.playing &&
          audioPlayerService.currentMedia != null &&
          (audioPlayerService.currentMedia!.lastPlayedTimestamp?.compareTo(
                      Timestamp.fromDateTime(
                          DateTime.now().subtract(audioPlayer.duration!))) ??
                  0) <
              5) {
        print(
            "$position :: ${audioPlayer.position} :: ${audioPlayer.duration} :: ${audioPlayerService.currentMedia?.lastPlayedTimestamp} :: ${Timestamp.fromDateTime(DateTime.now().subtract(audioPlayer.duration!))}");
        increasePlayCount(audioPlayerService.currentMedia!);
      }
    });
  }

  Future<void> addMediaByUri(final String uri) async {
    Database db = await database;

    if (await fileStore.record(uri).exists(db)) {
      print("addMediaByUri: uri already exists in fileStore");
      return;
    }

    if (mediaLibrary.containsKey(uri)) {
      print("addMediaByUri: uri already exists in mediaLibrary");
      return;
    }

    ID3Tag tag;
    try {
      tag =
          ID3TagReader.path(Uri.decodeFull(Uri.parse(uri).path)).readTagSync();
    } on FileSystemException {
      print("MediaLibraryService.addMediaByUri(): File not found");
      return;
    }

    Media media = Media(
      uri: uri,
      title: tag.title ?? uri.split('/').last,
      artist: tag.artist,
      album: tag.album,
      trackNumber: tag.track,
      playCount: 0,
      skipCount: 0,
      lastPlayedTimestamp: null,
      lastSkippedTimestamp: null,
    );

    await fileStore.record(uri).add(db, media.toFileMap());
    await syncStores(media);
    mediaLibrary[uri] = media;
    notifyListeners();
  }

  Future<void> syncStores(final Media media) async {
    Database db = await database;

    if (media.title != null &&
        media.artist != null &&
        media.album != null &&
        media.trackNumber != null) {
      var mediaMap = await mediaStore.findFirst(
        db,
        finder: Finder(
          filter: Filter.and([
            Filter.equals('title', media.title),
            Filter.equals('artist', media.artist),
            Filter.equals('album', media.album),
            Filter.equals('trackNumber', media.trackNumber),
          ]),
        ),
      );

      if (mediaMap == null) {
        await mediaStore.add(db, media.toMediaMap());
      } else {
        media.playCount = mediaMap.value['playCount'] as int;
        media.skipCount = mediaMap.value['skipCount'] as int;
        media.lastPlayedTimestamp =
            mediaMap.value['lastPlayedTimestamp'] as Timestamp?;
        media.lastSkippedTimestamp =
            mediaMap.value['lastSkippedTimestamp'] as Timestamp?;
        await fileStore.record(media.uri).update(db, media.toFileMap());
      }
    }
  }

  Future<void> increasePlayCount(final Media media) async {
    Database db = await database;

    var mediaMap = await mediaStore.findFirst(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('title', media.title),
          Filter.equals('artist', media.artist),
          Filter.equals('album', media.album),
          Filter.equals('trackNumber', media.trackNumber),
        ]),
      ),
    );

    media.lastPlayedTimestamp = Timestamp.now();
    if (mediaMap == null) {
      ++media.playCount;
    } else {
      media.playCount = (mediaMap.value['playCount'] as int) + 1;
      media.skipCount = mediaMap.value['skipCount'] as int;
      media.lastSkippedTimestamp =
          mediaMap.value['lastSkippedTimestamp'] as Timestamp?;

      await mediaStore.record(mediaMap.key).update(db, media.toMediaMap());
    }
    await fileStore.record(media.uri).update(db, media.toFileMap());
  }

  Future<void> increaseSkipCount(final Media media) async {
    Database db = await database;

    var mediaMap = await mediaStore.findFirst(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('title', media.title),
          Filter.equals('artist', media.artist),
          Filter.equals('album', media.album),
          Filter.equals('trackNumber', media.trackNumber),
        ]),
      ),
    );

    media.lastSkippedTimestamp = Timestamp.now();
    if (mediaMap == null) {
      ++media.skipCount;
    } else {
      media.playCount = mediaMap.value['playCount'] as int;
      media.skipCount = (mediaMap.value['skipCount'] as int) + 1;
      media.lastPlayedTimestamp =
          mediaMap.value['lastPlayedTimestamp'] as Timestamp?;

      await mediaStore.record(mediaMap.key).update(db, media.toMediaMap());
    }
    await fileStore.record(media.uri).update(db, media.toFileMap());
  }
}
