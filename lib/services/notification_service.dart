import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moonpatrol/utils/logger/debug_log.dart';

/// Service de gestion des notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialiser les notifications
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
    DebugLog.info('Service de notifications initialisé');
  }

  /// Callback quand l'utilisateur tape sur une notification
  void _onNotificationTap(NotificationResponse response) {
    DebugLog.info('Notification tapped: ${response.payload}');
  }

  /// Demander les permissions (iOS uniquement)
  Future<bool> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return result ?? true; // Android n'a pas besoin de permission
  }

  /// Notification de photo sauvegardée
  Future<void> notifyPhotoSaved({
    required int photoCount,
    bool hasGps = false,
    bool hasElevationApi = false,
  }) async {
    String body = 'Photo $photoCount sauvegardée';
    if (hasGps && hasElevationApi) {
      body += ' avec GPS et altitude API';
    } else if (hasGps) {
      body += ' avec GPS';
    }

    await _showNotification(
      id: 1,
      title: '📸 Photo enregistrée',
      body: body,
      payload: 'photo_saved',
    );
  }

  /// Notification d'envoi API réussi
  Future<void> notifyApiSuccess() async {
    await _showNotification(
      id: 2,
      title: 'Données envoyées',
      body: 'Photo et capteurs envoyés au serveur',
      payload: 'api_success',
    );
  }

  /// Notification d'erreur API
  Future<void> notifyApiError() async {
    await _showNotification(
      id: 3,
      title: 'Erreur serveur',
      body: 'Impossible d\'envoyer les données (photo sauvegardée localement)',
      payload: 'api_error',
    );
  }

  /// Notification GPS fix acquis
  Future<void> notifyGpsFixed() async {
    await _showNotification(
      id: 4,
      title: 'GPS acquis',
      body: 'Position GPS disponible',
      payload: 'gps_fixed',
    );
  }

  /// Notification altitude API récupérée
  Future<void> notifyElevationApiReceived(double elevation) async {
    await _showNotification(
      id: 5,
      title: 'Altitude API',
      body: 'Altitude précise : ${elevation.toStringAsFixed(1)} m',
      payload: 'elevation_api',
    );
  }

  /// Notification de progression (plusieurs photos)
  Future<void> notifyPhotoProgress({required int current, required int total}) async {
    await _showProgressNotification(
      id: 10,
      title: 'Traitement des photos',
      body: 'Photo $current/$total',
      progress: current,
      maxProgress: total,
    );
  }

  /// Afficher une notification simple
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'moonpatrol_channel',
      'MoonPatrol',
      channelDescription: 'Notifications de l\'application MoonPatrol',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Afficher une notification avec barre de progression
  Future<void> _showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'moonpatrol_progress_channel',
      'MoonPatrol Progress',
      channelDescription: 'Progression des traitements',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
      onlyAlertOnce: true,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(id, title, body, details);
  }

  /// Annuler une notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// Annuler toutes les notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
