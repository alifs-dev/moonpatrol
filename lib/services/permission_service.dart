import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

/// Service de gestion des permissions
class PermissionService {
  /// Demander toutes les permissions nécessaires
  static Future<void> requestAllPermissions() async {
    await [
      Permission.camera,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.photos, // iOS
      Permission.storage, // Android <= 12
    ].request();

    // Android 13+ nécessite des permissions spécifiques
    if (Platform.isAndroid) {
      await Permission.mediaLibrary.request();
    }
  }

  /// Vérifier si la permission GPS est accordée
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Vérifier si le service GPS est activé
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Ouvrir les paramètres de localisation
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Vérifier si la permission caméra est accordée
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Vérifier si la permission stockage est accordée
  static Future<bool> isStoragePermissionGranted() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        return await Permission.storage.status.isGranted;
      } else {
        return await Permission.photos.status.isGranted;
      }
    }

    return await Permission.photos.status.isGranted;
  }
}
