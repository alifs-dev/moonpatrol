import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Widget affichant les données des capteurs en overlay
class SensorOverlayWidget extends StatelessWidget {
  final Position? position;
  final AccelerometerEvent? accelerometer;
  final GyroscopeEvent? gyroscope;
  final MagnetometerEvent? magnetometer;
  final int? batteryLevel;
  final double? zoomLevel;

  const SensorOverlayWidget({
    super.key,
    this.position,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
    this.batteryLevel,
    this.zoomLevel,
  });

  String _formatAltitude(double? altitude) {
    if (altitude == null) return '---';
    if (altitude == 0.0) return '0 m (GPS 2D fix)';
    return '${altitude.toStringAsFixed(1)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSensorRow(
              'GPS',
              position != null
                  ? '${position!.latitude.toStringAsFixed(6)}, ${position!.longitude.toStringAsFixed(6)}'
                  : '🔍 Recherche GPS...',
            ),
            _buildSensorRow(
              'Alt.',
              _formatAltitude(position?.altitude),
              color: (position?.altitude == 0.0) ? Colors.orange : Colors.white,
            ),
            _buildSensorRow(
              'Précision',
              position != null ? '±${position!.accuracy.toStringAsFixed(1)} m' : '---',
            ),
            _buildSensorRow(
              'Vitesse',
              position != null ? '${position!.speed.toStringAsFixed(1)} m/s' : '---',
            ),
            _buildSensorRow(
              'Cap',
              position != null ? '${position!.heading.toStringAsFixed(0)}°' : '---',
            ),
            const Divider(color: Colors.white54, height: 16),
            _buildSensorRow(
              'Accél.',
              accelerometer != null
                  ? 'X:${accelerometer!.x.toStringAsFixed(1)} Y:${accelerometer!.y.toStringAsFixed(1)} Z:${accelerometer!.z.toStringAsFixed(1)}'
                  : 'N/A',
            ),
            _buildSensorRow(
              'Gyro.',
              gyroscope != null
                  ? 'X:${gyroscope!.x.toStringAsFixed(1)} Y:${gyroscope!.y.toStringAsFixed(1)} Z:${gyroscope!.z.toStringAsFixed(1)}'
                  : 'N/A',
            ),
            _buildSensorRow(
              'Magnét.',
              magnetometer != null
                  ? 'X:${magnetometer!.x.toStringAsFixed(0)} Y:${magnetometer!.y.toStringAsFixed(0)} Z:${magnetometer!.z.toStringAsFixed(0)}'
                  : 'N/A',
            ),
            _buildSensorRow('Zoom.', zoomLevel!.toStringAsFixed(3)),
            _buildSensorRow('Batt.', batteryLevel != null ? '$batteryLevel%' : 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorRow(String label, String value, {Color color = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
