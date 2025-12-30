import 'dart:async';
import 'dart:io';
import 'package:moonpatrol/utils/logger/debug_log.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Service de gestion des capteurs
class SensorService {
  // Données des capteurs
  AccelerometerEvent? _accelerometer;
  GyroscopeEvent? _gyroscope;
  MagnetometerEvent? _magnetometer;
  int? _batteryLevel;
  String? _deviceInfo;

  // Subscriptions
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<MagnetometerEvent>? _magSubscription;

  // Getters
  AccelerometerEvent? get accelerometer => _accelerometer;
  GyroscopeEvent? get gyroscope => _gyroscope;
  MagnetometerEvent? get magnetometer => _magnetometer;
  int? get batteryLevel => _batteryLevel;
  String? get deviceInfo => _deviceInfo;

  /// Initialiser tous les capteurs
  void initializeSensors(Function() onUpdate) {
    // Accéléromètre
    _accelSubscription = accelerometerEventStream().listen((event) {
      _accelerometer = event;
      onUpdate();
    });

    // Gyroscope
    _gyroSubscription = gyroscopeEventStream().listen((event) {
      _gyroscope = event;
      onUpdate();
    });

    // Magnétomètre
    _magSubscription = magnetometerEventStream().listen((event) {
      _magnetometer = event;
      onUpdate();
    });

    // Première lecture immédiate
    updateBattery();
    updateDeviceInfo();
  }

  /// Mettre à jour le niveau de batterie
  Future<void> updateBattery() async {
    try {
      final battery = Battery();
      _batteryLevel = await battery.batteryLevel;
    } catch (e) {
      DebugLog.error('Erreur batterie: $e');
    }
  }

  /// Obtenir les informations de l'appareil
  Future<void> updateDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceInfo = '''Modele: ${androidInfo.model}
  Fabricant: ${androidInfo.manufacturer}
  Android: ${androidInfo.version.release}''';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceInfo = '''Modele: ${iosInfo.model}
  Nom: ${iosInfo.name}
  iOS: ${iosInfo.systemVersion}''';
      }
    } catch (e) {
      DebugLog.error('Erreur device info: $e');
    }
  }

  /// Arrêter l'écoute des capteurs
  void dispose() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _magSubscription?.cancel();
  }
}
