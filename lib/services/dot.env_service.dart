import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moonpatrol/utils/logger/debug_log.dart';

/// Service de configuration depuis .env
class EnvConfig {
  // API URLs
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiForensicEndpoint => dotenv.env['API_FORENSIC_ENDPOINT'] ?? '';
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

  static int get batteryDuration =>
      int.tryParse(dotenv.env['UPDATE_BATTERY_DURATION']!) ?? 30;

  // Elevation API
  static String get elevationApiUrl =>
      dotenv.env['ELEVATION_API_URL'] ??
      'https://api.open-elevation.com/api/v1/lookup?locations=%s,%s';

  static int get apiElevationDuration =>
      int.tryParse(dotenv.env['UPDATE_ELEVATION_API_DURATION']!) ?? 30;

  static String get albumName => dotenv.env['ALBUM_NAME'] ?? 'Moon Patrol Album';

  // App Config
  static String get appName => dotenv.env['APP_NAME'] ?? 'Moon Patrol';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  // Debug
  static bool get enableLogs => dotenv.env['ENABLE_LOGS']?.toLowerCase() == 'false';

  /// Initialiser la configuration
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  /// Afficher la configuration (debug)
  static void printConfig() {
    DebugLog.info('🔧 Configuration ${EnvConfig.appName}:');
    DebugLog.info('  API URL: $apiForensicUrl');
    DebugLog.info('  Elevation API: $elevationApiUrl');
    DebugLog.info('  App: $appName v$appVersion');
    DebugLog.info('  Logs: $enableLogs');
  }
}
