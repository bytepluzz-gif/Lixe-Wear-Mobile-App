import 'package:flutter/material.dart';

class AddPaymentScreen extends StatelessWidget {
  const AddPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Payment Card")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: "Card Number", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(decoration: const InputDecoration(labelText: "Expiry Date (MM/YY)", border: OutlineInputBorder()))),
                const SizedBox(width: 16),
                Expanded(child: TextField(decoration: const InputDecoration(labelText: "CVV", border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 16),
            TextField(decoration: const InputDecoration(labelText: "Cardholder Name", border: OutlineInputBorder())),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Card added successfully")));
                },
                child: const Text("Add Card", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}