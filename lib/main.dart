import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fury_music/homepage.dart';
import 'package:provider/provider.dart';

import 'pages/music_genre_page.dart';
import 'pages/playlist_page.dart';
import 'pages/predict_page.dart';
import 'pages/select_file_page.dart';
import 'providers/music_provider.dart';
import 'providers/predict_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MusicProvider>(
            create: (context) => MusicProvider()),
        ChangeNotifierProvider<PredictProvider>(
            create: (context) => PredictProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Homepage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
