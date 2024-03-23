import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class PredictedLabel {
  final String? predictedLabel;

  const PredictedLabel({this.predictedLabel});

  @override
  String toString() => 'PredictedLabel(predictedLabel: $predictedLabel)';

  factory PredictedLabel.fromMap(Map<String, dynamic> data) {
    return PredictedLabel(
      predictedLabel: data['predicted_label'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'predicted_label': predictedLabel,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PredictedLabel].
  factory PredictedLabel.fromJson(String data) {
    return PredictedLabel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PredictedLabel] to a JSON string.
  String toJson() => json.encode(toMap());

  PredictedLabel copyWith({
    String? predictedLabel,
  }) {
    return PredictedLabel(
      predictedLabel: predictedLabel ?? this.predictedLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PredictedLabel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => predictedLabel.hashCode;
}
