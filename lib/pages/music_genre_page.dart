import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/recommend_model/recommend_model.dart';
import '../network_service.dart' as netWork;
import '../providers/predict_provider.dart';
import 'playlist_page.dart';

class MusicGenre extends StatefulWidget {
  const MusicGenre({super.key});

  @override
  State<MusicGenre> createState() => _MusicGenreState();
}

class _MusicGenreState extends State<MusicGenre> {
  String imageAsset = 'assets/images/guitar.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PredictProvider>(builder: (_, provider, child) {
          switch (provider.predictedLabel?.predictedLabel ?? '') {
            case 'Hip-Hop':
              imageAsset = 'assets/images/hat.jpg';
              break;
            case 'Pop':
              imageAsset = 'assets/images/mic.jpg';
              break;
            case 'Rock':
              imageAsset = 'assets/images/guitar.jpg';
              break;
            case 'Country':
              imageAsset = 'assets/images/cowboy.jpg';
              break;
          }
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg02.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Music\nGenre',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(65),
                  ),
                  child: Center(
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    (provider.predictedLabel?.predictedLabel ?? '')
                        .toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFDEBDE7),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: Color(0xFFDEBDE7),
                            ),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(6),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.grey,
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(180, 52),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayListPage()));
                      },
                      child: Text(
                        'Recommends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
