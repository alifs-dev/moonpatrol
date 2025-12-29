import 'dart:io';
import 'dart:convert';
import 'package:moonpatrol/services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_exif/native_exif.dart';
import 'package:gal/gal.dart';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import 'elevation_service.dart';

/// Service de sauvegarde des photos et données
class StorageService {
  final ElevationService _elevationService = ElevationService();
  // final ApiService _apiService = ApiService();

  /// Sauvegarder la photo avec les métadonnées dans la galerie
  Future<void> savePhotoWithMetadata(String imagePath, SensorData sensorData) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final directory = await getTemporaryDirectory();
      final photoFile = File('${directory.path}/photo_$timestamp.jpg');

      // Copier l'image temporaire
      final tempImage = File(imagePath);
      await tempImage.copy(photoFile.path);

      // Récupérer l'altitude via API
      double? elevationApi;
      if (sensorData.location != null) {
        elevationApi = await _elevationService.getElevation(
          sensorData.location!.latitude,
          sensorData.location!.longitude,
        );
      }

      // Écrire les métadonnées EXIF structurées
      await _writeExifData(photoFile.path, sensorData, elevationApi);

      // Sauvegarder dans la galerie avec Gal
      await Gal.putImage(photoFile.path, album: 'Moon Patrol');

      // Sauvegarder les données dans un fichier texte
      await _saveSensorTextFile(timestamp, sensorData, elevationApi);

      // await _apiService.postForensicJson(sensorData);

      debugPrint('📸 Photo sauvegardée dans la galerie');
    } catch (e) {
      debugPrint('❌ Erreur sauvegarde: $e');
      rethrow;
    }
  }

  /// Écrire les données EXIF dans l'image de manière structurée
  Future<void> _writeExifData(
    String imagePath,
    SensorData data,
    double? elevationApi,
  ) async {
    try {
      final exif = await Exif.fromPath(imagePath);

      // === GPS (Tags standards EXIF) ===
      if (data.location != null) {
        final lat = data.location!.latitude;
        final lon = data.location!.longitude;
        final alt = data.location!.altitude;

        await exif.writeAttributes({
          'GPSLatitude': lat.abs().toString(),
          'GPSLatitudeRef': lat >= 0 ? 'N' : 'S',
          'GPSLongitude': lon.abs().toString(),
          'GPSLongitudeRef': lon >= 0 ? 'E' : 'W',
          'GPSAltitude': alt.toString(),
          'GPSSpeed': data.location!.speed.toString(),
          'GPSImgDirection': data.location!.heading.toString(),
          'GPSMapDatum': 'WGS-84',
        });
      }

      // === TAGS PERSONNALISÉS MOONPATROL ===
      // Format: "clé:valeur;clé:valeur"

      final magnetoData =
          data.magnetometer != null
              ? 'x:${data.magnetometer!.x.toStringAsFixed(2)};y:${data.magnetometer!.y.toStringAsFixed(2)};z:${data.magnetometer!.z.toStringAsFixed(2)}'
              : 'N/A';

      final accelData =
          data.accelerometer != null
              ? 'x:${data.accelerometer!.x.toStringAsFixed(2)};y:${data.accelerometer!.y.toStringAsFixed(2)};z:${data.accelerometer!.z.toStringAsFixed(2)}'
              : 'N/A';

      final gyroData =
          data.gyroscope != null
              ? 'x:${data.gyroscope!.x.toStringAsFixed(2)};y:${data.gyroscope!.y.toStringAsFixed(2)};z:${data.gyroscope!.z.toStringAsFixed(2)}'
              : 'N/A';

      // === JSON COMPLET MOONPATROL ===
      final jsonData = {
        'moonpatrol': {
          'version': '1.0',
          'timestamp': data.timestamp.toIso8601String(),
          'zoom': data.zoomLevel,
          'gps':
              data.location != null
                  ? {
                    'latitude': data.location!.latitude,
                    'longitude': data.location!.longitude,
                    'altitude_gps': data.location!.altitude,
                    'altitude_api': elevationApi,
                    'accuracy': data.location!.accuracy,
                    'speed': data.location!.speed,
                    'heading': data.location!.heading,
                  }
                  : null,
          'sensors': {
            'accelerometer':
                data.accelerometer != null
                    ? {
                      'x': data.accelerometer!.x,
                      'y': data.accelerometer!.y,
                      'z': data.accelerometer!.z,
                      'unit': 'm/s²',
                    }
                    : null,
            'gyroscope':
                data.gyroscope != null
                    ? {
                      'x': data.gyroscope!.x,
                      'y': data.gyroscope!.y,
                      'z': data.gyroscope!.z,
                      'unit': 'rad/s',
                    }
                    : null,
            'magnetometer':
                data.magnetometer != null
                    ? {
                      'x': data.magnetometer!.x,
                      'y': data.magnetometer!.y,
                      'z': data.magnetometer!.z,
                      'unit': 'µT',
                    }
                    : null,
          },
          'battery': {'level': data.batteryLevel, 'unit': '%'},
          'device': data.deviceInfo,
        },
      };

      final jsonString = jsonEncode(jsonData);

      // === ÉCRITURE DANS LES TAGS EXIF ===
      // Note: native_exif ne supporte que les tags EXIF standards
      // On utilise donc les tags modifiables avec des noms clairs
      await exif.writeAttributes({
        // Identification
        'Make': 'MoonPatrol',
        'Model': 'Camera Sensors Pro',
        'Software': 'MoonPatrol v1.0',
        'ImageDescription': 'Photo avec donnees capteurs MoonPatrol',
        'ImageUniqueID': 'moonpatrol_${data.timestamp.millisecondsSinceEpoch}',

        // JSON complet dans UserComment (priorité de lecture)
        'UserComment': jsonString,

        'Artist': 'Moon Patrol',
        'Copyright': 'Moon Patrol',
      });

      await exif.close();

      debugPrint('✅ EXIF MoonPatrol structuré:');
      debugPrint(
        '  📍 GPS: ${data.location?.latitude.toStringAsFixed(6)}, ${data.location?.longitude.toStringAsFixed(6)}',
      );
      debugPrint('  🏔️ Altitude GPS: ${data.location?.altitude.toStringAsFixed(1)}m');
      debugPrint('  🌍 Altitude API: ${elevationApi?.toStringAsFixed(1) ?? "N/A"}m');
      debugPrint('  🧭 Magnetometre: $magnetoData');
      debugPrint('  📐 Accelerometre: $accelData');
      debugPrint('  🔄 Gyroscope: $gyroData');
      debugPrint('  🔋 Batterie: ${data.batteryLevel ?? "N/A"}%');
      debugPrint('  📄 JSON: ${jsonString.length} caracteres');
    } catch (e) {
      debugPrint('⚠️ Erreur écriture EXIF: $e');
    }
  }

  /// Sauvegarder les données dans un fichier texte
  Future<void> _saveSensorTextFile(
    int timestamp,
    SensorData data,
    double? elevationApi,
  ) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final sensorFile = File('${documentsDir.path}/photo_${timestamp}_sensors.txt');

      // Ajouter l'altitude API au texte
      String textData = data.toString();
      if (elevationApi != null) {
        textData +=
            '\nALTITUDE API:\n  Elevation: ${elevationApi.toStringAsFixed(2)} m\n';
      }

      await sensorFile.writeAsString(textData);
      debugPrint('📊 Fichier texte sauvegardé: ${sensorFile.path}');
    } catch (e) {
      debugPrint('⚠️ Erreur sauvegarde texte: $e');
    }
  }

  /// Obtenir le chemin du répertoire de sauvegarde
  Future<String> getSaveDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
