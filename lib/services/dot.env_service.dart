import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moonpatrol/utils/logger/debug_log.dart';

/// Service de configuration depuis .env
class EnvConfig {
  // API URLs
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
  static String get apiForensicEndpoint =>
      dotenv.env['API_FORENSIC_ENDPOINT'] ?? '/api/forensic';
  static String get apiForensicUrl => '$apiBaseUrl$apiForensicEndpoint';

  static double get zoomLevel {
    final value = dotenv.env['ZOOM_LEVEL'];

    final zoom = double.tryParse(value ?? '');
    if (zoom == null) {
      DebugLog.warning('ZOOM_LEVEL invalide ($value), valeur par défaut utilisée');
      return 1.0;
    }

    return zoom;
  }

  // Elevation API
  static String get elevationApiUrl =>
      dotenv.env['ELEVATION_API_URL'] ?? 'https://api.open-elevation.com/api/v1/lookup';

  static String get albumName => dotenv.env['ALBUM_NAME'] ?? 'Moon Patrol Album';

  // App Config
  static String get appName => dotenv.env['APP_NAME'] ?? 'MoonPatrol';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  // Debug
  static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static bool get enableLogs => dotenv.env['ENABLE_LOGS']?.toLowerCase() == 'true';

  /// Initialiser la configuration
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  /// Afficher la configuration (debug)
  static void printConfig() {
    if (!debugMode) return;

    print('🔧 Configuration MoonPatrol:');
    print('  API URL: $apiForensicUrl');
    print('  Elevation API: $elevationApiUrl');
    print('  App: $appName v$appVersion');
    print('  Debug: $debugMode');
    print('  Logs: $enableLogs');
  }
}
