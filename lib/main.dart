import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orchestra/audio_helpers/page_manager.dart';
import 'package:orchestra/audio_helpers/service_locator.dart';
import 'package:orchestra/common/color_extension.dart';
import 'package:orchestra/provider/song_model_provider.dart';
import 'package:orchestra/view/splash_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(
    ChangeNotifierProvider(create: (context) => SongModelProvider(), child: const MyApp(),)
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
    requestPermission();
  }

  void requestPermission(){
    Permission.storage.request();
  }

  @override
  void dispose() {
    
    super.dispose();
    getIt<PageManager>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: GetMaterialApp(
      title: 'Orchestra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Circular Std",
        scaffoldBackgroundColor: TColor.bg,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: TColor.primaryText,
          displayColor: TColor.primaryText,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
        ),
        useMaterial3: false,
      ),
      home: const SplashView(),
    )
    );
  }
}
