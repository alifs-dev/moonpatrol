import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moonpatrol/features/camera/zoomable_camera_preview.dart';
import '../models/sensor_data.dart';
import '../services/camera_service.dart';
import '../services/sensor_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/permission_service.dart';
import '../widgets/sensor_overlay_widget.dart';
import '../widgets/camera_button_widget.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // Services
  final CameraService _cameraService = CameraService();
  final SensorService _sensorService = SensorService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  // État
  bool _isCapturing = false;
  String _status = 'Prêt';
  Position? _currentPosition;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _requestPermissions();
    await _cameraService.initialize(widget.cameras);
    _sensorService.initializeSensors(() => setState(() {}));
    _startLocationUpdates();
  }

  Future<void> _requestPermissions() async {
    await PermissionService.requestAllPermissions();

    // Vérifier GPS
    final locationGranted = await PermissionService.isLocationPermissionGranted();
    final serviceEnabled = await PermissionService.isLocationServiceEnabled();

    if (!locationGranted) {
      _showMessage('⚠️ Permission GPS refusée', Colors.orange);
    } else if (!serviceEnabled) {
      _showGpsDisabledMessage();
    }
  }

  void _startLocationUpdates() {
    // Première mise à jour immédiate
    _updateLocation();

    // Mise à jour périodique toutes les 3 secondes
    Timer.periodic(const Duration(seconds: 3), (_) {
      _updateLocation();
    });

    // Mise à jour batterie toutes les 30 secondes
    Timer.periodic(const Duration(seconds: 30), (_) {
      _sensorService.updateBattery();
    });
  }

  Future<void> _updateLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null && mounted) {
      setState(() => _currentPosition = position);
    }
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
      _status = 'Capture en cours...';
    });

    try {
      final image = await _cameraService.takePicture();
      if (image == null) {
        throw Exception('Échec de la capture');
      }

      // Créer l'objet SensorData
      final sensorData = SensorData(
        timestamp: DateTime.now(),
        location: _currentPosition,
        accelerometer: _sensorService.accelerometer,
        gyroscope: _sensorService.gyroscope,
        magnetometer: _sensorService.magnetometer,
        batteryLevel: _sensorService.batteryLevel,
        deviceInfo: _sensorService.deviceInfo,
        zoomLevel: _cameraService.currentZoomLevel,
      );

      // Sauvegarder
      await _storageService.savePhotoWithMetadata(image.path, sensorData);

      setState(() => _status = 'Photo enregistrée !');
      _showMessage('📸 Photo sauvegardée dans la galerie !', Colors.green);
      // _showMessage('Data upload!', success ? Colors.green : Colors.red);
    } catch (e) {
      setState(() => _status = 'Erreur: $e');
      _showMessage('❌ Erreur: $e', Colors.red);
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showGpsDisabledMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('⚠️ GPS désactivé. Activez-le dans les paramètres.'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 30),
        action: SnackBarAction(
          label: 'Paramètres',
          textColor: Colors.white,
          onPressed: () => PermissionService.openLocationSettings(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _sensorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraService.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Prévisualisation caméra
          // CameraPreview(_cameraService.controller!),
          ZoomableCameraPreview(
            controller: _cameraService.controller!,
            onZoomChanged: (zoom) {
              setState(() => _zoomLevel = zoom);
              _cameraService.setZoomLevel(zoom);
            },
          ),
          // Overlay avec les données des capteurs
          SensorOverlayWidget(
            position: _currentPosition,
            accelerometer: _sensorService.accelerometer,
            gyroscope: _sensorService.gyroscope,
            magnetometer: _sensorService.magnetometer,
            batteryLevel: _sensorService.batteryLevel,
            zoomLevel: _zoomLevel,
          ),

          // Message de statut
          if (_status.isNotEmpty && _status != 'Prêt')
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _status,
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Bouton de capture
          CameraButtonWidget(isCapturing: _isCapturing, onPressed: _takePicture),
        ],
      ),
    );
  }
}
