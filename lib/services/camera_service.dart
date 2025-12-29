import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

double _currentZoomLevel = 1.0;

/// Service de gestion de la caméra
class CameraService {
  CameraController? _controller;

  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  double get currentZoomLevel => _currentZoomLevel;

  void setZoomLevel(double zoom) {
    _currentZoomLevel = zoom;
  }

  /// Initialiser la caméra
  Future<bool> initialize(List<CameraDescription> cameras) async {
    if (cameras.isEmpty) {
      debugPrint('❌ Aucune caméra disponible');
      return false;
    }

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      debugPrint('✅ Caméra initialisée');
      return true;
    } catch (e) {
      debugPrint('❌ Erreur initialisation caméra: $e');
      return false;
    }
  }

  /// Prendre une photo
  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('❌ Caméra non initialisée');
      return null;
    }

    try {
      final image = await _controller!.takePicture();
      debugPrint('✅ Photo capturée: ${image.path}');
      return image;
    } catch (e) {
      debugPrint('❌ Erreur capture photo: $e');
      return null;
    }
  }

  /// Changer de caméra (avant/arrière)
  Future<void> switchCamera(List<CameraDescription> cameras) async {
    if (cameras.length < 2) return;

    final currentCamera = _controller?.description;
    final newCamera = cameras.firstWhere(
      (camera) => camera.lensDirection != currentCamera?.lensDirection,
      orElse: () => cameras.first,
    );

    await dispose();
    await initialize([newCamera]);
  }

  /// Libérer les ressources de la caméra
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
