import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fury_music/models/recommend_model/sorted_track.dart';
import 'package:fury_music/providers/predict_provider.dart';
import 'package:provider/provider.dart';

import '../components/recommend_card.dart';
import '../models/recommend_model/recommend_model.dart';
import '../network_service.dart' as netWork;
import 'package:url_launcher/url_launcher.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<RecommendModel?> _loadRecommends() async {
    try {
      netWork.NetworkService service = netWork.NetworkService();
      var provider = Provider.of<PredictProvider>(context, listen: false);
      var resp = await service
          .recommendsapi(provider.predictedLabel?.predictedLabel ?? '');
      if (resp?.statusCode == 200) {
        RecommendModel recommendModel = RecommendModel.fromJson(resp!.body);
        print('recommendModel');
        print(recommendModel.sortedTracks?.first);
        if (resp?.statusCode == 200) {
          RecommendModel respModel = RecommendModel.fromJson(resp!.body);
          return respModel;
        }
      }
    } catch (ex) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wallpaper.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        margin: EdgeInsets.only(top: 8, left: 8),
                        decoration: BoxDecoration(
                            color: Color(0xFFEC93C9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 2,
                                  color: Colors.black45)
                            ]),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('Fury',
                    style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'harlowsi',
                        color: Colors.white)),
                FutureBuilder(
                    future: _loadRecommends(),
                    builder: (BuildContext context,
                        AsyncSnapshot<RecommendModel?> snapshot) {
                      if (snapshot.hasData) {
                        RecommendModel recommendModel = snapshot.data!;
                        List<SortedTrack> sortedTracks =
                            recommendModel.sortedTracks!;
                        Widget columns = Column(
                            children:
                                List.generate(sortedTracks.length, (index) {
                          return RecommendCard(
                            name: sortedTracks[index].name ?? '',
                            artist: sortedTracks[index].artist ?? '',
                            coverImage: sortedTracks[index].coverImage ?? '',
                            previewUrl: sortedTracks[index].previewUrl ?? '',
                            popularity: sortedTracks[index].popularity ?? 0,
                            spotifyLink: sortedTracks[index].spotifyLink ?? '',
                            onOpenSpotify: () {
                              final spotifyUrl =
                                  sortedTracks[index].spotifyLink ?? '';
                              launch(spotifyUrl);
                            },
                          );
                        }));
                        return columns;
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
