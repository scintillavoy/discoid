import 'dart:async';
import 'dart:io';

import 'package:discoid/models/track.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:id3tag/id3tag.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/timestamp.dart';

class MediaLibraryService extends ChangeNotifier {
  StreamSubscription<Duration>? increasePlayCountSubscription;
  Map<String, Track> allTracks = <String, Track>{};
  late Future<Database> database;
  var fileStore = stringMapStoreFactory.store('file');
  var trackStore = intMapStoreFactory.store('track');

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

        Track track = Track(
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

        await syncStores(track);
        allTracks[fileMap.key] = track;
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
          audioPlayerService.currentTrack != null &&
          (audioPlayerService.currentTrack!.lastPlayedTimestamp?.compareTo(
                      Timestamp.fromDateTime(
                          DateTime.now().subtract(audioPlayer.duration!))) ??
                  0) <
              5) {
        print(
            "$position :: ${audioPlayer.position} :: ${audioPlayer.duration} :: ${audioPlayerService.currentTrack?.lastPlayedTimestamp} :: ${Timestamp.fromDateTime(DateTime.now().subtract(audioPlayer.duration!))}");
        increasePlayCount(audioPlayerService.currentTrack!);
      }
    });
  }

  Future<void> addTrackByUri(final String uri) async {
    Database db = await database;

    if (await fileStore.record(uri).exists(db)) {
      print("addTrackByUri: uri already exists in fileStore");
      return;
    }

    if (allTracks.containsKey(uri)) {
      print("addTrackByUri: uri already exists in allTracks");
      return;
    }

    ID3Tag tag;
    try {
      tag =
          ID3TagReader.path(Uri.decodeFull(Uri.parse(uri).path)).readTagSync();
    } on FileSystemException {
      print("MediaLibraryService.addTrackByUri(): File not found");
      return;
    }

    Track track = Track(
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

    await fileStore.record(uri).add(db, track.toFileMap());
    await syncStores(track);
    allTracks[uri] = track;
    notifyListeners();
  }

  Future<void> syncStores(final Track track) async {
    Database db = await database;

    if (track.title != null &&
        track.artist != null &&
        track.album != null &&
        track.trackNumber != null) {
      var trackMap = await trackStore.findFirst(
        db,
        finder: Finder(
          filter: Filter.and([
            Filter.equals('title', track.title),
            Filter.equals('artist', track.artist),
            Filter.equals('album', track.album),
            Filter.equals('trackNumber', track.trackNumber),
          ]),
        ),
      );

      if (trackMap == null) {
        await trackStore.add(db, track.toTrackMap());
      } else {
        track.playCount = trackMap.value['playCount'] as int;
        track.skipCount = trackMap.value['skipCount'] as int;
        track.lastPlayedTimestamp =
            trackMap.value['lastPlayedTimestamp'] as Timestamp?;
        track.lastSkippedTimestamp =
            trackMap.value['lastSkippedTimestamp'] as Timestamp?;
        await fileStore.record(track.uri).update(db, track.toFileMap());
      }
    }
  }

  Future<void> increasePlayCount(final Track track) async {
    Database db = await database;

    var trackMap = await trackStore.findFirst(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('title', track.title),
          Filter.equals('artist', track.artist),
          Filter.equals('album', track.album),
          Filter.equals('trackNumber', track.trackNumber),
        ]),
      ),
    );

    track.lastPlayedTimestamp = Timestamp.now();
    if (trackMap == null) {
      ++track.playCount;
    } else {
      track.playCount = (trackMap.value['playCount'] as int) + 1;
      track.skipCount = trackMap.value['skipCount'] as int;
      track.lastSkippedTimestamp =
          trackMap.value['lastSkippedTimestamp'] as Timestamp?;

      await trackStore.record(trackMap.key).update(db, track.toTrackMap());
    }
    await fileStore.record(track.uri).update(db, track.toFileMap());
  }

  Future<void> increaseSkipCount(final Track track) async {
    Database db = await database;

    var trackMap = await trackStore.findFirst(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('title', track.title),
          Filter.equals('artist', track.artist),
          Filter.equals('album', track.album),
          Filter.equals('trackNumber', track.trackNumber),
        ]),
      ),
    );

    track.lastSkippedTimestamp = Timestamp.now();
    if (trackMap == null) {
      ++track.skipCount;
    } else {
      track.playCount = trackMap.value['playCount'] as int;
      track.skipCount = (trackMap.value['skipCount'] as int) + 1;
      track.lastPlayedTimestamp =
          trackMap.value['lastPlayedTimestamp'] as Timestamp?;

      await trackStore.record(trackMap.key).update(db, track.toTrackMap());
    }
    await fileStore.record(track.uri).update(db, track.toFileMap());
  }
}
