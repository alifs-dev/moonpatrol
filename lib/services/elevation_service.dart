import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// Service pour récupérer l'altitude via API (sans clé)
class ElevationService {
  // API gratuite sans clé : Open-Elevation
  static const String _baseUrl = 'https://api.open-elevation.com/api/v1/lookup';

  /// Récupérer l'altitude pour des coordonnées GPS
  /// Retourne l'altitude en mètres, ou null en cas d'erreur
  Future<double?> getElevation(double latitude, double longitude) async {
    try {
      final url = Uri.parse('$_baseUrl?locations=$latitude,$longitude');

      debugPrint('🌍 Requête altitude API: $url');

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final elevation = data['results'][0]['elevation'];

        debugPrint('✅ Altitude API récupérée: ${elevation}m');
        return elevation.toDouble();
      } else {
        debugPrint('⚠️ Erreur API altitude: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération altitude: $e');
      return null;
    }
  }

  /// Alternative : Batch request pour plusieurs points (économise les appels)
  Future<List> getElevations(List<Map<String, double>> locations) async {
    try {
      // Format: lat1,lon1|lat2,lon2|lat3,lon3
      final locationsStr = locations
          .map((loc) => '${loc['lat']},${loc['lon']}')
          .join('|');

      final url = Uri.parse('$_baseUrl?locations=$locationsStr');

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        return results.map((r) => r['elevation']?.toDouble()).toList();
      }

      return List.filled(locations.length, null);
    } catch (e) {
      debugPrint('❌ Erreur batch altitude: $e');
      return List.filled(locations.length, null);
    }
  }
}
