import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/orientation_data.dart';

class OrientationService {
  OrientationData? compute({
    required AccelerometerEvent accel,
    required GyroscopeEvent gyro,
    required MagnetometerEvent mag,
  }) {
    // --- Inclinaison (accéléro)
    final pitch = atan2(accel.x, sqrt(accel.y * accel.y + accel.z * accel.z));

    final roll = atan2(accel.y, accel.z);

    // --- Azimut (magnétomètre)
    final yaw = atan2(mag.y, mag.x);

    // --- Altitude caméra (astronomie)
    final altitude = pi / 2 - pitch.abs();

    return OrientationData(
      pitch: pitch * 180 / pi,
      roll: roll * 180 / pi,
      yaw: (yaw * 180 / pi + 360) % 360,
      altitude: altitude * 180 / pi,
    );
  }
}
