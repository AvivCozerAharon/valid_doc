import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Web e Windows não têm suporte — ignora silenciosamente
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleDocumentNotifications({
    required int baseId,
    required String docName,
    required String valDate,
  }) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) return;

    await cancelDocumentNotifications(baseId);

    DateTime expiry;
    try {
      expiry = DateFormat('dd/MM/yyyy').parse(valDate);
    } catch (_) {
      try {
        expiry = DateFormat('d/M/yyyy').parse(valDate);
      } catch (_) {
        return;
      }
    }

    final now = DateTime.now();
    final formatted = DateFormat('dd/MM/yyyy').format(expiry);

    final alerts = [
      _Alert(baseId * 10 + 1, '📄 Documento expira em 2 anos',
          '$docName vence em $formatted', const Duration(days: 365 * 2)),
      _Alert(baseId * 10 + 2, '⚠️ Documento expira em 1 ano',
          '$docName vence em $formatted', const Duration(days: 365)),
      _Alert(baseId * 10 + 3, '🔶 Documento expira em 6 meses',
          '$docName vence em $formatted', const Duration(days: 183)),
      _Alert(baseId * 10 + 4, '🔴 Documento expira em 3 meses',
          '$docName vence em $formatted', const Duration(days: 90)),
      _Alert(baseId * 10 + 5, '🚨 Documento expira em 1 mês!',
          '$docName vence em $formatted', const Duration(days: 30)),
    ];

    for (final alert in alerts) {
      final notifyAt = expiry.subtract(alert.offset);
      if (notifyAt.isAfter(now)) {
        await _schedule(
          id: alert.id,
          title: alert.title,
          body: alert.body,
          scheduledDate: notifyAt,
        );
      }
    }
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'valid_doc_channel',
      'Validade de Documentos',
      channelDescription: 'Alertas de vencimento de documentos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelDocumentNotifications(int baseId) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) return;
    for (int i = 1; i <= 5; i++) {
      await _plugin.cancel(baseId * 10 + i);
    }
  }

  static Future<void> rescheduleAll(List documentsList) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) return;
    for (int i = 0; i < documentsList.length; i++) {
      await scheduleDocumentNotifications(
        baseId: i,
        docName: documentsList[i][0],
        valDate: documentsList[i][3],
      );
    }
  }
}

class _Alert {
  final int id;
  final String title;
  final String body;
  final Duration offset;
  const _Alert(this.id, this.title, this.body, this.offset);
}
