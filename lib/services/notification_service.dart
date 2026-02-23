import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool get _supported =>
      !kIsWeb && defaultTargetPlatform != TargetPlatform.windows;

  // ── Inicialização ──────────────────────────────────────────────────────────
  static Future<void> init() async {
    if (!_supported) return;

    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ── Agendamento de alertas ─────────────────────────────────────────────────
  //
  // 5 alertas progressivos antes do vencimento:
  //   2 anos → 1 ano → 6 meses → 3 meses → 1 mês
  //
  // Cada notificação só é agendada se:
  //   1. A data calculada ainda está no futuro
  //   2. O documento não venceu (expiry > now)
  //
  static Future<void> scheduleDocumentNotifications({
    required int baseId,
    required String docName,
    required String valDate,
  }) async {
    if (!_supported) return;

    await cancelDocumentNotifications(baseId);

    final expiry = _parseDate(valDate);
    if (expiry == null) return;

    final now = DateTime.now();

    // Documento já vencido — não agenda nada
    if (!expiry.isAfter(now)) return;

    final formatted = DateFormat('dd/MM/yyyy').format(expiry);
    final daysLeft = expiry.difference(now).inDays;

    // Define os alertas com antecedência em dias
    final offsets = [
      _AlertOffset(id: baseId * 10 + 1, daysBefore: 365 * 2, urgency: _Urgency.info),
      _AlertOffset(id: baseId * 10 + 2, daysBefore: 365,     urgency: _Urgency.warning),
      _AlertOffset(id: baseId * 10 + 3, daysBefore: 183,     urgency: _Urgency.alert),
      _AlertOffset(id: baseId * 10 + 4, daysBefore: 90,      urgency: _Urgency.urgent),
      _AlertOffset(id: baseId * 10 + 5, daysBefore: 30,      urgency: _Urgency.critical),
    ];

    for (final a in offsets) {
      // Só agenda alertas que ainda não passaram
      if (daysLeft <= a.daysBefore) continue;

      final notifyAt = expiry.subtract(Duration(days: a.daysBefore));
      if (!notifyAt.isAfter(now)) continue;

      await _scheduleOne(
        id: a.id,
        title: a.urgency.emoji + ' ' + _titleFor(a.urgency),
        body: '$docName vence em $formatted',
        scheduledDate: notifyAt,
      );
    }
  }

  static String _titleFor(_Urgency u) {
    switch (u) {
      case _Urgency.info:     return 'Documento expira em 2 anos';
      case _Urgency.warning:  return 'Documento expira em 1 ano';
      case _Urgency.alert:    return 'Documento expira em 6 meses';
      case _Urgency.urgent:   return 'Documento expira em 3 meses';
      case _Urgency.critical: return 'Documento expira em 1 mês!';
    }
  }

  // ── Agendamento único ──────────────────────────────────────────────────────
  static Future<void> _scheduleOne({
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
      color: _kGreen,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      // Falha silenciosa — pode acontecer se permissões de alarme exato
      // não foram concedidas no Android 12+
      debugPrint('NotificationService: failed to schedule $id — $e');
    }
  }

  // ── Cancelamento ──────────────────────────────────────────────────────────
  static Future<void> cancelDocumentNotifications(int baseId) async {
    if (!_supported) return;
    for (int i = 1; i <= 5; i++) {
      await _plugin.cancel(baseId * 10 + i);
    }
  }

  static Future<void> cancelAll() async {
    if (!_supported) return;
    await _plugin.cancelAll();
  }

  // ── Re-agendar todos ───────────────────────────────────────────────────────
  // Chamado após delete/edição para recalcular todos os índices
  static Future<void> rescheduleAll(List documentsList) async {
    if (!_supported) return;
    await cancelAll();
    for (int i = 0; i < documentsList.length; i++) {
      final doc = documentsList[i];
      if (doc == null || doc.length < 4) continue;
      await scheduleDocumentNotifications(
        baseId: i,
        docName: doc[0] as String? ?? '',
        valDate: doc[3] as String? ?? '',
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  static DateTime? _parseDate(String v) {
    for (final fmt in ['dd/MM/yyyy', 'd/M/yyyy', 'MM/dd/yyyy']) {
      try {
        return DateFormat(fmt).parse(v);
      } catch (_) {}
    }
    return null;
  }

  static const _kGreen = Color(0xFF558459);
}

// ignore: constant_identifier_names
enum _Urgency { info, warning, alert, urgent, critical }

extension on _Urgency {
  String get emoji {
    switch (this) {
      case _Urgency.info:     return '📄';
      case _Urgency.warning:  return '⚠️';
      case _Urgency.alert:    return '🔶';
      case _Urgency.urgent:   return '🔴';
      case _Urgency.critical: return '🚨';
    }
  }
}

class _AlertOffset {
  final int id;
  final int daysBefore;
  final _Urgency urgency;
  const _AlertOffset({
    required this.id,
    required this.daysBefore,
    required this.urgency,
  });
}


