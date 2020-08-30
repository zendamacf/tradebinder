import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  int id;
  String title;
  String body;

  AndroidFlutterLocalNotificationsPlugin plugin;
  String channelId = 'tradebinder';

  void cancel() {
    plugin.cancel(id);
  }

  Notification(int id, String title, String body, {bool persist=true}) {
    this.id = id;
    this.title = title;
    this.body = body;

    plugin = AndroidFlutterLocalNotificationsPlugin();


    var settings = AndroidInitializationSettings('@mipmap/ic_launcher');
    plugin.initialize(settings);

    // Delete channel, as the below will only create, not create and/or update
    plugin.deleteNotificationChannel(channelId);

    var details = AndroidNotificationDetails(
        channelId,
        'Trade Binder',
        'Trade Binder notifications.',
        importance: Importance.Low,  // Silent without popup
        priority: Priority.Low,
        ticker: this.title,
        enableVibration: false,
        ongoing: persist  //  Whether to allow dismissing the notification
    );

    plugin.show(
        this.id,
        this.title,
        this.body,
        notificationDetails: details
    );
  }
}
