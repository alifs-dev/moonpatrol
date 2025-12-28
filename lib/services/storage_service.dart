import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:native_exif/native_exif.dart';
import 'package:gal/gal.dart';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

/// Service de sauvegarde des photos et données
class StorageService {
  /// Sauvegarder la photo avec les métadonnées dans la galerie
  Future<void> savePhotoWithMetadata(String imagePath, SensorData sensorData) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final directory = await getTemporaryDirectory();
      final photoFile = File('${directory.path}/photo_$timestamp.jpg');

      // Copier l'image temporaire
      final tempImage = File(imagePath);
      await tempImage.copy(photoFile.path);

      // Écrire les métadonnées EXIF
      await _writeExifData(photoFile.path, sensorData);

      // Sauvegarder dans la galerie avec Gal
      await Gal.putImage(photoFile.path, album: 'Camera Sensors');

      // Sauvegarder les données dans un fichier texte
      await _saveSensorTextFile(timestamp, sensorData);

      debugPrint('📸 Photo sauvegardée dans la galerie');
    } catch (e) {
      debugPrint('❌ Erreur sauvegarde: $e');
      rethrow;
    }
  }

  /// Écrire les données EXIF dans l'image
  Future<void> _writeExifData(String imagePath, SensorData data) async {
    try {
      final exif = await Exif.fromPath(imagePath);

      // GPS
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
        });
      }

      // Capteurs dans les commentaires
      await exif.writeAttributes({
        'UserComment': data.toExifComment(),
        'ImageDescription': 'Photo avec données capteurs',
        'Software': 'Camera Sensors Pro',
      });

      await exif.close();
      debugPrint('✅ Métadonnées EXIF écrites');
    } catch (e) {
      debugPrint('⚠️ Erreur écriture EXIF: $e');
    }
  }

  /// Sauvegarder les données dans un fichier texte
  Future<void> _saveSensorTextFile(int timestamp, SensorData data) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final sensorFile = File('${documentsDir.path}/photo_${timestamp}_sensors.txt');
      await sensorFile.writeAsString(data.toString());
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
