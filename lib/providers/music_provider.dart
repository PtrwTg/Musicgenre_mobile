import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/select_wav_model.dart';

class MusicProvider extends ChangeNotifier {
  SelectWavModel? selectWavModel;

  Future<void> setSelectWavModel(String name, String path, File file) async {
    selectWavModel =
        SelectWavModel(musicName: name, musicPath: path, musicFile: file);
    notifyListeners();
  }
}
