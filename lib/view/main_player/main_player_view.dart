import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orchestra/common_widget/player_bottom_button.dart';
import 'package:orchestra/provider/song_model_provider.dart';
import 'package:orchestra/view/main_player/driver_mode_view.dart';
import 'package:orchestra/view/main_player/play_playlist_view.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../common/color_extension.dart';

class MainPlayerView extends StatefulWidget {
  const MainPlayerView({super.key, required this.songModel, required this.audioPlayer});
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<MainPlayerView> createState() => _MainPlayerViewState();
}

class _MainPlayerViewState extends State<MainPlayerView> {

  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  List<AudioSource> songList = [];

  void seekToSeconds(int seconds){
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    parseSong();
  }

  void parseSong(){
    try {
      widget.audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.songModel.uri!),
        tag: MediaItem(
          id: widget.songModel.id.toString(),
          album: widget.songModel.album ?? "No Album",
          title: widget.songModel.displayNameWOExt,
          artUri: Uri.parse(widget.songModel.id.toString())),
      )
    );

    widget.audioPlayer.play();
    _isPlaying = true;

    widget.audioPlayer.durationStream.listen((duration) {
      if (duration != null){
        setState(() {
          _duration = duration;
        });
      }
    });
    widget.audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });
    listenToEvent();
    } on Exception catch (_){
      Get.back();
    }
  }

  void listenToEvent(){
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing){
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed){
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            //widget.audioPlayer.stop();
            Get.back();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          "Joué maintenant",
          style: TextStyle(
              color: TColor.primaryText80,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
        actions: [
           PopupMenuButton<int>(
                    color: const Color(0xff383B49),
                    offset: const Offset(-10, 15),
                    elevation: 1,
                    icon: Image.asset(
                      "assets/img/more_btn.png",
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                    
                    padding: EdgeInsets.zero,
                    onSelected: (selectIndex) {
                        if(selectIndex == 9) {
                          Get.to( () => const DriverModeView() );
                        }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          height: 30,
                          child: Text(
                            "Partage Social",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 2,
                           height: 30,
                          child: Text(
                            "Liste de lecture",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                         const PopupMenuItem(
                          value: 3,
                          height: 30,
                          child: Text(
                            "Ajouter au playlist...",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                         const PopupMenuItem(
                          value: 4,
                           height: 30,
                          child: Text(
                            "Paroles",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                         const PopupMenuItem(
                          value: 5,
                          height: 30,
                          child: Text(
                            "Volume",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                         const PopupMenuItem(
                          value: 6,
                          height: 30,
                          child: Text(
                            "Details",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                         const PopupMenuItem(
                          value: 7,
                          height: 30,
                          child: Text(
                            "Timer de veille",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 8,
                          height: 30,
                          child: Text(
                            "Equaliseur",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 9,
                          height: 30,
                          child: Text(
                            "Mode conduite",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ];
                    }),
             

         
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.width * 0.7),
                  child: const ArtWorkWidget(),
                ),
                SizedBox(
                  width: media.width * 0.6,
                  height: media.width * 0.6,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(
                            trackWidth: 4, progressBarWidth: 6, shadowWidth: 8),
                        customColors: CustomSliderColors(
                            dotColor: const Color(0xffFFB1B2),
                            trackColor:
                                const Color(0xffffffff).withOpacity(0.3),
                            progressBarColors: [
                              const Color(0xffFB9967),
                              const Color(0xffE9585A)
                            ],
                            shadowColor: const Color(0xffFFB1B2),
                            shadowMaxOpacity: 0.05),
                        infoProperties: InfoProperties(
                          topLabelStyle: const TextStyle(
                              color: Colors.transparent,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          topLabelText: 'Elapsed',
                          bottomLabelStyle: const TextStyle(
                              color: Colors.transparent,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          bottomLabelText: 'time',
                          mainLabelStyle: const TextStyle(
                              color: Colors.transparent,
                              fontSize: 50.0,
                              fontWeight: FontWeight.w600),
                          // modifier: (double value) {
                          //   final time = printDuration(Duration(seconds: value.toInt()));
                          //   return '$time';
                          // }
                        ),
                        startAngle: 270,
                        angleRange: 360,
                        size: 350.0),
                    min: 0.0,
                    max: _duration.inSeconds.toDouble() + 1.0,
                    initialValue: _position.inSeconds.toDouble(),
                    onChange: (double value) {
                      setState(() {
                        seekToSeconds(value.toInt());
                        value = value;
                      });
                    },
                    onChangeStart: (double startValue) {
                      // callback providing a starting value (when a pan gesture starts)
                    },
                    onChangeEnd: (double endValue) {
                      // ucallback providing an ending value (when a pan gesture ends)
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${_position.toString().split('.')[0]} | ${_duration.toString().split('.')[0]}",
              style: TextStyle(color: TColor.secondaryText, fontSize: 12),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              widget.songModel.displayNameWOExt,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: TextStyle(
                  color: TColor.primaryText.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.songModel.artist}" == "<unknown>" ? "Unknown Artist" : "${widget.songModel.artist}",
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: TextStyle(color: TColor.secondaryText, fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/img/eq_display.png",
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Divider(
                color: Colors.white12,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: IconButton(
                    onPressed: () {
                      if(widget.audioPlayer.hasPrevious){
                        widget.audioPlayer.seekToPrevious();
                      }
                    },
                    icon: Image.asset(
                      "assets/img/previous_song.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if(_isPlaying) {
                          widget.audioPlayer.pause();
                        } else{
                          widget.audioPlayer.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Image.asset(_isPlaying ? "assets/img/pause.png" : "assets/img/play.png",
                                color: TColor.primaryText,)
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 45,
                  height: 45,
                  child: IconButton(
                    onPressed: () {
                      if(widget.audioPlayer.hasNext){
                        widget.audioPlayer.seekToNext();
                      }
                    },
                    icon: Image.asset(
                      "assets/img/next_song.png",
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerBottomButton(
                    title: "Playlist",
                    icon: "assets/img/playlist.png",
                    onPressed: () {
                      Get.to( () => const PlayPlayListView() );
                    }),
                PlayerBottomButton(
                    title: "Aléatoire",
                    icon: "assets/img/shuffle.png",
                    onPressed: () {}),
                PlayerBottomButton(
                    title: "Repeter",
                    icon: "assets/img/repeat.png",
                    onPressed: () {}),
                PlayerBottomButton(
                    title: "EQ",
                    icon: "assets/img/eq.png",
                    onPressed: () {}),
                 PlayerBottomButton(
                    title: "Favoris",
                    icon: "assets/img/fav.png",
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    var media = MediaQuery.sizeOf(context);
    return QueryArtworkWidget(
                            id: context.watch<SongModelProvider>().id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Image.asset('assets/img/songs_tab.png', width: media.width * 0.6, height: media.width * 0.6),
                            artworkHeight: media.width * 0.6,
                            artworkWidth: media.width * 0.6,
                            artworkFit: BoxFit.cover,
                          );
  }
}
