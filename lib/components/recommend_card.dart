import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fury_music/components/player_music.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'common2.dart';

class RecommendCard extends StatelessWidget {
  final String name, coverImage, artist, previewUrl, spotifyLink;
  final int popularity;
  final _player = AudioPlayer();
  final VoidCallback onOpenSpotify;
  RecommendCard({
    super.key,
    required this.name,
    required this.coverImage,
    required this.artist,
    required this.previewUrl,
    required this.popularity,
    required this.spotifyLink,
    required this.onOpenSpotify,
  });

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    setPLayer() async {
      try {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(previewUrl)));
      } catch (e) {
        print("Error loading audio source: $e");
      }
    }

    setPLayer();
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 140,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/noise-bad-signa.jpg'),
                  fit: BoxFit.cover,
                  opacity: .02),
              color: Colors.white30,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image:
                            DecorationImage(image: NetworkImage(coverImage))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: onOpenSpotify,
                          child: SizedBox(
                            child: Text(
                              name,
                              maxLines: 3,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onOpenSpotify,
                          child: Text(
                            artist,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 3),
                          width: _width - 170,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              ControlButtons(_player),
                              StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  return SeekBar2(
                                    duration:
                                        positionData?.duration ?? Duration.zero,
                                    position:
                                        positionData?.position ?? Duration.zero,
                                    bufferedPosition:
                                        positionData?.bufferedPosition ??
                                            Duration.zero,
                                    onChangeEnd: _player.seek,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
