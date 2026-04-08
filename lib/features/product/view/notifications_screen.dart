import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today Section
            const Text(
              "Today",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _notificationCard(
              "Order Updates",
              "Your order #FASH3921 has been shipped. Track your order now.",
              "2h ago",
              "https://picsum.photos/id/201/600/400",
            ),

            const SizedBox(height: 30),

            // This Week
            const Text(
              "This Week",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _notificationCard(
              "New Arrivals",
              "Fresh drop: Linen Essentials collection is now live.",
              "Yesterday",
              "https://picsum.photos/id/870/600/400",
            ),
            const SizedBox(height: 12),
            _notificationCard(
              "Promotions",
              "Get 20% off on your first order with code WELCOME20",
              "3 days ago",
              null,
            ),

            const SizedBox(height: 40),

            // Settings Toggles
            const Text(
              "Notification Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _toggleTile("Order Updates", true),
            _toggleTile("New Arrivals", true),
            _toggleTile("Promotions", false),
            _toggleTile("Style Tips", true),
            _toggleTile("Do Not Disturb", false),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7043),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text("Save Preferences"),
              ),
            ),
          ],
        ),
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

  Widget _toggleTile(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (bool newValue) {},
      activeThumbColor: const Color(0xFF4A7043),
    );
  }
}
