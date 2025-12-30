import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:moonpatrol/utils/logger/debug_log.dart';
import 'package:moonpatrol/models/sensor_data.dart';
import 'dot.env_service.dart';

/// Service d'API pour envoyer les données forensic
class ApiService {
  /// Envoyer la photo et les données capteurs à l'API
  Future<bool> sendForensicData({
    required String imagePath,
    required SensorData sensorData,
    double? elevationApi,
  }) async {
    try {
      DebugLog.warning('Envoi des données à l\'API...');

      // Lire le fichier image
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);

      // Construire le JSON complet
      final payload = {
        'image': {
          'data': imageBase64,
          'filename': imagePath.split('/').last,
          'mime_type': 'image/jpeg',
          'size_bytes': imageBytes.length,
        },
        'metadata': {
          'timestamp': sensorData.timestamp.toIso8601String(),
          'version': EnvConfig.appVersion,
        },
        'gps':
            sensorData.location != null
                ? {
                  'latitude': sensorData.location!.latitude,
                  'longitude': sensorData.location!.longitude,
                  'altitude_gps': sensorData.location!.altitude,
                  'altitude_api': elevationApi,
                  'accuracy': sensorData.location!.accuracy,
                  'speed': sensorData.location!.speed,
                  'heading': sensorData.location!.heading,
                }
                : null,
        'sensors': {
          'accelerometer':
              sensorData.accelerometer != null
                  ? {
                    'x': sensorData.accelerometer!.x,
                    'y': sensorData.accelerometer!.y,
                    'z': sensorData.accelerometer!.z,
                    'unit': 'm/s²',
                  }
                  : null,
          'gyroscope':
              sensorData.gyroscope != null
                  ? {
                    'x': sensorData.gyroscope!.x,
                    'y': sensorData.gyroscope!.y,
                    'z': sensorData.gyroscope!.z,
                    'unit': 'rad/s',
                  }
                  : null,
          'magnetometer':
              sensorData.magnetometer != null
                  ? {
                    'x': sensorData.magnetometer!.x,
                    'y': sensorData.magnetometer!.y,
                    'z': sensorData.magnetometer!.z,
                    'unit': 'µT',
                  }
                  : null,
        },
        'device': {
          'battery_level': sensorData.batteryLevel,
          'info': sensorData.deviceInfo,
        },
      };

      // Envoyer à l'API
      final url = Uri.parse(EnvConfig.apiForensicUrl);

      DebugLog.info('URL: $url');
      DebugLog.info(
        '📦 Taille image: ${(imageBytes.length / 1024).toStringAsFixed(2)} KB',
      );
      DebugLog.info('Taille JSON: ${jsonEncode(payload).length} caractères');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        DebugLog.info('Données envoyées avec succès');
        DebugLog.info('Réponse: ${response.body}');
        return true;
      } else {
        DebugLog.error('Erreur API: ${response.statusCode}');
        DebugLog.error('Réponse: ${response.body}');
        return false;
      }
    } catch (e) {
      DebugLog.error('Erreur envoi API: $e');
      return false;
    }
  }

  /// Tester la connexion à l'API
  Future<bool> testConnection() async {
    try {
      final url = Uri.parse(EnvConfig.apiBaseUrl);
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      DebugLog.info('Test connexion API: ${response.statusCode}');
      return response.statusCode < 500;
    } catch (e) {
      DebugLog.error('API non accessible: $e');
      return false;
    }
  }
}
