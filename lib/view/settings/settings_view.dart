import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orchestra/common_widget/icon_text_row.dart';
import 'package:orchestra/view_model/splash_view_model.dart';

import '../../common/color_extension.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.find<SplashViewMode>().openDrawer();
          },
          icon: Image.asset(
            "assets/img/menu.png",
            width: 25,
            height: 25,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          "Paramètres",
          style: TextStyle(
              color: TColor.primaryText80,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          IconTextRow(
            title: "Affichage",
            icon: "assets/img/s_display.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Audio",
            icon: "assets/img/s_audio.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Casques",
            icon: "assets/img/s_headset.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Ecran de veille",
            icon: "assets/img/s_lock_screen.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Avancée",
            icon: "assets/img/s_menu.png",
            onTap: () {},
          ),

          IconTextRow(
            title: "Autres",
            icon: "assets/img/s_other.png",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
