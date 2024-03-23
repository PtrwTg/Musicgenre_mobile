import 'package:flutter/material.dart';
import 'package:fury_music/components/common.dart';
import 'package:just_audio/just_audio.dart';

class PredictPlayerButtons extends StatelessWidget {
  final AudioPlayer player;

  const PredictPlayerButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(
            Icons.volume_up,
            color: Color.fromARGB(255, 111, 63, 129),
            size: 30,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                margin: const EdgeInsets.all(8.0),
                width: 30.0,
                height: 30.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Color(0xFFCCA4DD),
                  ),
                  iconSize: 30.0,
                  onPressed: player.play,
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.pause,
                    color: Color(0xFFCCA4DD),
                  ),
                  iconSize: 30.0,
                  onPressed: player.pause,
                ),
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.replay,
                    color: Color(0xFFCCA4DD),
                  ),
                  iconSize: 30.0,
                  onPressed: () => player.seek(Duration.zero),
                ),
              );
            }
          },
        ),

        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
