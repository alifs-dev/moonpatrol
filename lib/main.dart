import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:moonpatrol/services/dot.env_service.dart';
import 'package:moonpatrol/screens/permission_screen.dart';
import 'package:moonpatrol/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger la configuration .env
  await EnvConfig.initialize();
  EnvConfig.printConfig();

  // Initialiser les notifications
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  // Obtenir les caméras disponibles
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: EnvConfig.appName,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      // Démarrer par l'écran de permissions
      home: PermissionScreen(cameras: cameras),
    );
  }
}
