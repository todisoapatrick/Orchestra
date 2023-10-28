import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orchestra/view/main_player/main_player_view.dart';


class AllSongsView extends StatefulWidget {
  const AllSongsView({super.key});

  @override
  State<AllSongsView> createState() => _AllSongsViewState();
}

class _AllSongsViewState extends State<AllSongsView> {
  final _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
      ),
      builder: (context, item){
        if(item.data == null){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(item.data!.isEmpty){
          return const Center(
            child: Text("Aucun Musique trouvé")
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) => ListTile(
            leading: Image.asset('assets/img/songs_tab.png', width: 25, height: 25),
            title: Text(item.data![index].displayNameWOExt, 
                        maxLines: 1,
                        style: TextStyle(
                        color: TColor.primaryText60,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),),
            subtitle: Text("${item.data![index].artist}", 
                            maxLines: 1,
                            style: TextStyle(color: TColor.primaryText28, fontSize: 10)),
            trailing: IconButton(
              onPressed: () {Get.to(() => const MainPlayerView());},
              icon: Image.asset(
                "assets/img/play_btn.png",
                width: 25,
                height: 25,
              ),
            ),
          ),
          itemCount: item.data!.length,
        );
      },
    )
    );
  }
}
