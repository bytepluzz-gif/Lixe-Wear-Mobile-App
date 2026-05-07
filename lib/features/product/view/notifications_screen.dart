import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../core/firestore_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
      ),
      body: uid == null
          ? const Center(child: Text('Please sign in'))
          : StreamBuilder(
              stream: context.read<FirestoreService>().notificationsStream(uid),
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];
                if (notifications.isEmpty) {
                  return const Center(child: Text('No notifications yet'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final data = notifications[index].data();
                    return _notificationCard(
                      data['title'] as String? ?? 'Update',
                      data['message'] as String? ?? '',
                      'recently',
                      null,
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _notificationCard(
    String title,
    String message,
    String time,
    String? imageUrl,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(message, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
