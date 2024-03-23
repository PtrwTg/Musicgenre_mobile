import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class SortedTrack {
  final String? name;
  final String? artist;
  final String? coverImage;
  final dynamic previewUrl;
  final int? popularity;
  final String? spotifyLink;

  const SortedTrack({
    this.name,
    this.artist,
    this.coverImage,
    this.previewUrl,
    this.popularity,
    this.spotifyLink,
  });

  @override
  String toString() {
    return 'SortedTrack(name: $name, artist: $artist, coverImage: $coverImage, previewUrl: $previewUrl, popularity: $popularity, spotifyLink: $spotifyLink)';
  }

  factory SortedTrack.fromMap(Map<String, dynamic> data) => SortedTrack(
        name: data['name'] as String?,
        artist: data['artist'] as String?,
        coverImage: data['cover_image'] as String?,
        previewUrl: data['preview_url'] as dynamic,
        popularity: data['popularity'] as int?,
        spotifyLink: data['spotify_link'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'artist': artist,
        'cover_image': coverImage,
        'preview_url': previewUrl,
        'popularity': popularity,
        'spotify_link': spotifyLink,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SortedTrack].
  factory SortedTrack.fromJson(String data) {
    return SortedTrack.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SortedTrack] to a JSON string.
  String toJson() => json.encode(toMap());

  SortedTrack copyWith({
    String? name,
    String? artist,
    String? coverImage,
    dynamic previewUrl,
    int? popularity,
    String? spotifyLink,
  }) {
    return SortedTrack(
      name: name ?? this.name,
      artist: artist ?? this.artist,
      coverImage: coverImage ?? this.coverImage,
      previewUrl: previewUrl ?? this.previewUrl,
      popularity: popularity ?? this.popularity,
      spotifyLink: spotifyLink ?? this.spotifyLink,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SortedTrack) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      name.hashCode ^
      artist.hashCode ^
      coverImage.hashCode ^
      previewUrl.hashCode ^
      popularity.hashCode ^
      spotifyLink.hashCode;
}
