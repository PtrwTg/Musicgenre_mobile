import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fury_music/providers/music_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'predict_page.dart';

class SelectFilePage extends StatefulWidget {
  const SelectFilePage({super.key});

  @override
  State<SelectFilePage> createState() => _SelectFilePageState();
}

class _SelectFilePageState extends State<SelectFilePage> {
  String _fileName = 'Select .WAV File';
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/holo_bg.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Music Genre\nclasssifications',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Color.fromARGB(255, 127, 109, 206),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/noise-bad-signa.jpg'),
                              fit: BoxFit.cover,
                              opacity: .02),
                          color: Colors.white30,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  var provider = Provider.of<MusicProvider>(
                                      context,
                                      listen: false);

                                  var file = File(result.paths[0] ?? '');
                                  provider.setSelectWavModel(
                                      result.names[0] ?? '', file.path, file);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PredictPage()));
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 55,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Color(0xFFEC93C9),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: Text(
                                    _fileName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Tap to Input File',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
