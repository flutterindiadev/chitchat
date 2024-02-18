import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fcm {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final androidchannel = const AndroidNotificationChannel(
      'high_importance_channel', "High Importance Notificaiotns",
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    final fcmToken = await _firebaseMessaging.getToken();

    print("fcmToken ======>${fcmToken!}");

    _prefs.setString('fcmtoken', fcmToken);

    initPushNotification();

    initLocalNotifications();
  }

  initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings);

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(androidchannel);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) {
        final notification = message.notification;

        if (notification == null) return;

        _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  androidchannel.id, androidchannel.name,
                  channelDescription: androidchannel.description,
                  icon: '@drawable/ic_launcher'),
            ),
            payload: jsonEncode(message.toMap()));
      },
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('title : ===> ${message.notification!.title}');

  print('body : ===> ${message.notification!.body}');

  print('payload : ===> ${message.data}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  // navigatorKey.currentState?.pushNamed()
}
