import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:moonpatrol/features/http/localhost.dart';
import 'package:moonpatrol/screens/splash_screen.dart';
import 'package:moonpatrol/services/dot.env_service.dart';
import 'package:moonpatrol/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verrouillage en mode portrait uniquement
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top], // Garde seulement la barre du haut
  );

  // Configuration de la barre de statut pour tous les appareils
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // Charger la configuration .env
  await EnvConfig.initialize();
  EnvConfig.printConfig();

  // Initialiser les notifications
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  // Obtenir les caméras disponibles
  final cameras = await availableCameras();
  if (kDebugMode) HttpOverrides.global = MyHttpOverrides();

  runApp(MoonPatrol(cameras: cameras));
}

class MoonPatrol extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MoonPatrol({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: EnvConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Démarrer par l'écran de permissions
      // home: PermissionScreen(cameras: cameras),
      home: SplashScreen(cameras: cameras),
    );
  }
}
