import 'dart:io';

import 'package:flutter/material.dart';

import '../models/predicted_label.dart';
import '../models/select_wav_model.dart';

class PredictProvider extends ChangeNotifier {
  PredictedLabel? predictedLabel;

  void setPredict(
    PredictedLabel predict,
  ) {
    predictedLabel = predict;
    notifyListeners();
  }
}
