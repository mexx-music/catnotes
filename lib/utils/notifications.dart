import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class Notifications {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    InitializationSettings settings;
    if (Platform.isMacOS) {
      const macos = DarwinInitializationSettings();
      settings = const InitializationSettings(android: android, iOS: ios, macOS: macos);
    } else {
      settings = const InitializationSettings(android: android, iOS: ios);
    }
    await _plugin.initialize(settings);
  }

  static Future<void> schedule(String id, String title, String body, DateTime dateTime) async {
    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('cat_notes_reminders', 'Cat Notes Reminders'),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancel(String id) async {
    await _plugin.cancel(id.hashCode);
  }
}
