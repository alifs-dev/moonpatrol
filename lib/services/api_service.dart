import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moonpatrol/models/sensor_data.dart';

class ApiService {
  late final String _baseUrl;

  ApiService() {
    // _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (_baseUrl.isEmpty) {
      throw Exception('API_BASE_URL non défini dans le fichier .env');
    }
  }

  /// POST un JSON forensic vers le serveur
  Future<bool> postForensicJson(SensorData jsonData) async {
    try {
      final uri = Uri.parse('$_baseUrl/forensic'); // endpoint /forensic
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        if (kDebugMode) {
          print('Erreur API: ${response.statusCode} ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur API: $e');
      }
      return false;
    }
  }
}
