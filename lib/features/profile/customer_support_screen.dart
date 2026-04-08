import 'package:flutter/material.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Support")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chat with Agent
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF4A7043),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text("Need help right now?", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("Our team is online", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF4A7043)),
                    child: const Text("CHAT WITH AN AGENT"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Contact Options
            const Text("Get in touch", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _supportOption("Email Us", "We reply within 24 hours", Icons.email),
            _supportOption("Call Us", "+94 11 234 5678", Icons.phone),

            const SizedBox(height: 40),

            // Frequent Topics
            const Text("Frequent Topics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                Chip(label: Text("Returns")),
                Chip(label: Text("Refunds")),
                Chip(label: Text("Shipping")),
                Chip(label: Text("Sizing Guide")),
                Chip(label: Text("Gift Cards")),
              ],
            ),

            const SizedBox(height: 30),

            // Gift Cards & Rewards
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const ListTile(
                leading: Icon(Icons.card_giftcard, color: Color(0xFF4A7043)),
                title: Text("Gift Cards & Rewards"),
                subtitle: Text("Check your balance and redeem points"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),

            const SizedBox(height: 20),

            // Image Banner (from your screenshot)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "https://picsum.photos/id/1015/800/300",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Text("Respect privacy. We never share your data.", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _supportOption(String title, String subtitle, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4A7043)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {},
      ),
    );
  }
}