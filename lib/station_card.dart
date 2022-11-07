import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';

class StationCard {
  final String id;
  final String station;
  final String? song;
  final String stationUrl;
  final Uint8List? stationArtwork;
  const StationCard({
    required this.id,
    required this.station,
    this.song,
    required this.stationUrl,
    this.stationArtwork,
  });

  StationCard copyWith({
    String? id,
    String? station,
    String? song,
    String? stationUrl,
    Uint8List? stationArtwork,
  }) {
    return StationCard(
      id: id ?? this.id,
      station: station ?? this.station,
      song: song ?? this.song,
      stationUrl: stationUrl ?? this.stationUrl,
      stationArtwork: stationArtwork ?? this.stationArtwork,
    );
  }

  static StationCard fromMediaItem(MediaItem mediaItem) {
    return StationCard(
      id: mediaItem.id,
      station: mediaItem.album ?? '<None>',
      song: mediaItem.title,
      stationUrl: mediaItem.extras?['url'],
    );
  }

  static MediaItem toMediaItem(StationCard stationCard) {
    return MediaItem(
      id: stationCard.id,
      album: stationCard.station,
      title: stationCard.song ?? '',
      extras: {'url': stationCard.stationUrl},
    );
  }
}

const StationCard defaultStationCard =
    StationCard(id: 'EmptyPlaylist', station: '', stationUrl: '');
