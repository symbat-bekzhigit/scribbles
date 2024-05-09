import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:messaging_app/services/auth/login_or_resgister.dart";
import "package:messaging_app/pages/welcome_page.dart";
import "package:messaging_app/services/notification/notification_service_paging.dart";


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationService notificationService = NotificationService();

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If a user is authenticated, listen to their notification document
            User user = snapshot.data as User;
            notificationService.listenToNotificationDocument(user.uid);

            return const WelcomePage();
          } else {
            return const LoginOrRegister();
          }
        },
        )
    );
  }
}