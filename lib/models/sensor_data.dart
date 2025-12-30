import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

/// Modèle pour stocker toutes les données des capteurs
class SensorData {
  final DateTime timestamp;
  final Position? location;
  final AccelerometerEvent? accelerometer;
  final GyroscopeEvent? gyroscope;
  final MagnetometerEvent? magnetometer;
  final int? batteryLevel;
  final String? deviceInfo;
  final double zoomLevel;

  SensorData({
    required this.timestamp,
    this.location,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
    this.batteryLevel,
    this.deviceInfo,
    required this.zoomLevel,
  });

  /// Convertir les données en format texte lisible
  @override
  String toString() {
    return '''
=== DONNÉES CAPTEURS ===
Horodatage: $timestamp
ZoomLevel: $zoomLevel
LOCALISATION:
${location != null ? '''
  Latitude: ${location!.latitude}
  Longitude: ${location!.longitude}
  Altitude: ${location!.altitude} m
  Précision: ${location!.accuracy} m
  Vitesse: ${location!.speed} m/s
  Cap: ${location!.heading}°
''' : '  Non disponible'}

ACCÉLÉROMÈTRE (m/s²):
${accelerometer != null ? '''
  X: ${accelerometer!.x.toStringAsFixed(2)}
  Y: ${accelerometer!.y.toStringAsFixed(2)}
  Z: ${accelerometer!.z.toStringAsFixed(2)}
''' : '  Non disponible'}

GYROSCOPE (rad/s):
${gyroscope != null ? '''
  X: ${gyroscope!.x.toStringAsFixed(2)}
  Y: ${gyroscope!.y.toStringAsFixed(2)}
  Z: ${gyroscope!.z.toStringAsFixed(2)}
''' : '  Non disponible'}

MAGNÉTOMÈTRE (µT):
${magnetometer != null ? '''
  X: ${magnetometer!.x.toStringAsFixed(2)}
  Y: ${magnetometer!.y.toStringAsFixed(2)}
  Z: ${magnetometer!.z.toStringAsFixed(2)}
''' : '  Non disponible'}

BATTERIE:
  Niveau: ${batteryLevel ?? 'N/A'}%

APPAREIL:
$deviceInfo
========================
''';
  }

  /// Obtenir une description courte pour les métadonnées EXIF (sans accents)
  String toExifComment() {
    return '''
Accelerometre: ${accelerometer != null ? 'X:${accelerometer!.x.toStringAsFixed(2)} Y:${accelerometer!.y.toStringAsFixed(2)} Z:${accelerometer!.z.toStringAsFixed(2)}' : 'N/A'}
Gyroscope: ${gyroscope != null ? 'X:${gyroscope!.x.toStringAsFixed(2)} Y:${gyroscope!.y.toStringAsFixed(2)} Z:${gyroscope!.z.toStringAsFixed(2)}' : 'N/A'}
Magnetometre: ${magnetometer != null ? 'X:${magnetometer!.x.toStringAsFixed(0)} Y:${magnetometer!.y.toStringAsFixed(0)} Z:${magnetometer!.z.toStringAsFixed(0)}' : 'N/A'}
Batterie: ${batteryLevel ?? 'N/A'}%
${deviceInfo ?? ''}''';
  }
}
