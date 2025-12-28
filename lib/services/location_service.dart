import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

/// Service de gestion de la localisation GPS
class LocationService {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  /// Obtenir la position actuelle
  Future<Position?> getCurrentPosition() async {
    try {
      // Vérifier si le service est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ Service de localisation désactivé');
        return null;
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('⚠️ Permission de localisation refusée');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ Permission de localisation refusée définitivement');
        return null;
      }

      // Obtenir la position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition = position;
      debugPrint('✅ GPS acquis: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('❌ Erreur localisation: $e');
      return null;
    }
  }

  /// Écouter les changements de position en temps réel
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Mise à jour tous les 5 mètres
      ),
    );
  }

  /// Calculer la distance entre deux positions
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
