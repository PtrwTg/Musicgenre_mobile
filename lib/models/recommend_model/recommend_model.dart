import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'sorted_track.dart';

@immutable
class RecommendModel {
  final List<SortedTrack>? sortedTracks;

  const RecommendModel({this.sortedTracks});

  @override
  String toString() => 'RecommendModel(sortedTracks: $sortedTracks)';

  factory RecommendModel.fromMap(Map<String, dynamic> data) {
    return RecommendModel(
      sortedTracks: (data['sorted_tracks'] as List<dynamic>?)
          ?.map((e) => SortedTrack.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'sorted_tracks': sortedTracks?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RecommendModel].
  factory RecommendModel.fromJson(String data) {
    return RecommendModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RecommendModel] to a JSON string.
  String toJson() => json.encode(toMap());

  RecommendModel copyWith({
    List<SortedTrack>? sortedTracks,
  }) {
    return RecommendModel(
      sortedTracks: sortedTracks ?? this.sortedTracks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! RecommendModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => sortedTracks.hashCode;
}
