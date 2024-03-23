import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fury_music/pages/music_genre_page.dart';
import 'package:fury_music/providers/music_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../components/common.dart';
import '../components/player_button_predict.dart';
import '../components/player_music.dart';
import '../models/predicted_label.dart';
import '../network_service.dart' as netWork;
import '../providers/predict_provider.dart';
import 'package:rxdart/rxdart.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final _player = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    var musicProvider = Provider.of<MusicProvider>(context, listen: false);
    setPLayer(musicProvider.selectWavModel?.musicPath ?? '');
    super.initState();
  }

  setPLayer(String Path) async {
    try {
      await _player.setAudioSource(AudioSource.file(Path));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MusicProvider>(builder: (_, provider, child) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    'assets/images/disk.jpg',
                    fit: BoxFit.fill,
                    height: 220,
                  ),
                ),
                Center(
                  child: Text(
                    provider.selectWavModel?.musicName ?? '',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
                PredictPlayerButtons(_player),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFDEBDE7),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    netWork.NetworkService service = netWork.NetworkService();
                    _player.dispose();

                    EasyLoading.show(
                        status: 'predict...',
                        maskType: EasyLoadingMaskType.black);
                    var resp = await service.PredictApi(
                        provider.selectWavModel!.musicFile!);
                    if (resp?.statusCode == 200) {
                      var provider =
                          Provider.of<PredictProvider>(context, listen: false);
                      var respStr = await resp?.stream.bytesToString();
                      PredictedLabel predictedLabel =
                          PredictedLabel.fromJson(respStr ?? '');
                      provider.setPredict(predictedLabel);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicGenre()));
                    }
                    EasyLoading.dismiss();
                  },
                  child: Text(
                    'predict',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
