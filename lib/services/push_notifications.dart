
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../utils/hive_manager.dart';


class FirebaseAPI{
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool? notificationOpenedTheApp;

  static void subscribeToNewTopic(String topic){
    final _firebaseMSG = FirebaseMessaging.instance;
    _firebaseMSG.subscribeToTopic(topic);
  }

  final _androidChannel = const AndroidNotificationChannel(
      'notification_channel_important',
      'High Importance Notification',
      description: "This channel is user for important notifications",
      importance: Importance.max,
      playSound: true
  );

  Future<void> _showBackgroundNotification(RemoteMessage message) async {
    await FlutterLocalNotificationsPlugin().show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'notification_channel_important',
          'High Importance Notification',
          playSound: true,
          priority: Priority.high,
          importance: Importance.max,
          icon: 'notification_icon',
          color: Color(0xFF000000), // Set background color to black
          channelShowBadge: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
        ),
      ),
      payload: message.data['payload'] ?? '',
    );
  }

  void handleMessage(RemoteMessage? message) async {
    await _showBackgroundNotification(message!);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null)return;
      _flutterLocalNotificationsPlugin.show(0, message.notification!.title!, message.notification!.body!, const NotificationDetails(
        android: AndroidNotificationDetails(
          'notification_channel_important',
          'High Importance Notification',
          playSound: true,
          priority: Priority.high,
          importance: Importance.max,
          // icon: 'notification_icon',
          // color: Color(0xFF000000),
          channelShowBadge: true,
        ),
        iOS: DarwinNotificationDetails(
            presentAlert: true,
          presentSound: true,
          presentBadge: true,
        ),
      ));
      // showSimpleNotification(title: message.notification!.title!, body: message.notification!.body!, payload: message.data['payload'] ?? "");
    });

  }

  Future<void> initNotifications() async {
    var box = HiveStorageManager.hiveBox;
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
        if(Platform.isIOS){
      String? aPNSToken = await _firebaseMessaging.getAPNSToken();
      if(aPNSToken == null){
        await Future.delayed(const Duration(seconds: 2));
        aPNSToken = await _firebaseMessaging.getAPNSToken();
      }
      box.put('firebaseToken', aPNSToken);
      print("APNSToken: $aPNSToken");
    }else{
      final token = await _firebaseMessaging.getToken();
      print("Token: $token");
      box.put('firebaseToken', token);
    }
          
    _firebaseMessaging.subscribeToTopic("allUsers");
    initPushNotifications();
    initLocalNotification();
  }

  Future initLocalNotification() async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/notification_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      // onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    // const settings = InitializationSettings( iOS: iOS);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);


    final platform = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/notifications", arguments: notificationResponse);
  }
}