import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NotificationService() {
    _initLocalNotifications();
  }

  Future<void> _initLocalNotifications() async {
    var iosInitializationSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    var initializationSettings = InitializationSettings(iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification
    );
  }

  void listenToNotificationDocument(String userId) {
    debugPrint("Starting to listen to notifications for user $userId");
    FirebaseFirestore.instance.collection('user_notifications').doc(userId).snapshots().listen((documentSnapshot) {
      debugPrint("Received document snapshot for user $userId");
      if (documentSnapshot.exists && documentSnapshot.data()?['alert'] == true) {
        var data = documentSnapshot.data()!;
        String message = data['message'] ?? "No message";
        String sender = data['senderEmail'] ?? "Unknown sender";
        String recipient = data['recipientEmail'] ?? "Unknown recipient";
        String location = data['location'] ?? "No location";
        String type = data['notificationType'] ?? "General";

        debugPrint("Preparing to show notification: $message from $sender");
        // Check if the current user is the recipient
        if (_auth.currentUser?.email == recipient) {
          showNotificationDialog('Incoming Paging Request from $sender', 'Location: $location\nType: $type\nMessage: $message\n');
        }
        FirebaseFirestore.instance.collection('user_notifications').doc(userId).update({'alert': false});
        debugPrint("Notification alert flag reset for user $userId");
      } else {
        debugPrint("No new notifications or alert flag not set.");
      }
    }, onError: (error) {
      debugPrint("Error listening to notification document: $error");
    });
  }


  void showNotificationDialog(String title, String message) {
    if (navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  // Other methods remain the same...
  Future onSelectNotification(String? payload) async {
  debugPrint('Notification tapped by user with payload: $payload');
}

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    debugPrint("Received local notification: $title, $body");
    // Handle non-UI logic here or pass the data back to UI via a stream or callback
  }
}
