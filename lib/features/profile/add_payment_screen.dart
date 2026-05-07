import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/firestore_service.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();
  final holder = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    cardNumber.dispose();
    expiry.dispose();
    cvv.dispose();
    holder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Payment Card")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: cardNumber, decoration: const InputDecoration(labelText: "Card Number", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: expiry, decoration: const InputDecoration(labelText: "Expiry Date (MM/YY)", border: OutlineInputBorder()))),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: cvv, decoration: const InputDecoration(labelText: "CVV", border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: holder, decoration: const InputDecoration(labelText: "Cardholder Name", border: OutlineInputBorder())),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saving
                    ? null
                    : () async {
                  if (cardNumber.text.trim().replaceAll(' ', '').length < 12) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter valid card number")),
                    );
                    return;
                  }
                  if (expiry.text.trim().isEmpty || cvv.text.trim().length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter valid expiry and CVV")),
                    );
                    return;
                  }
                  if (holder.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter cardholder name")),
                    );
                    return;
                  }
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) return;
                  final digitsOnly = cardNumber.text.replaceAll(RegExp(r'\D'), '');
                  try {
                    setState(() => _saving = true);
                    await context.read<FirestoreService>().addCard(uid, {
                      'last4': digitsOnly.length >= 4
                          ? digitsOnly.substring(digitsOnly.length - 4)
                          : digitsOnly,
                      'expiry': expiry.text.trim(),
                      'holder': holder.text.trim(),
                      'brand': 'Card',
                    });
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Card added successfully")),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to save card: $e")),
                    );
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Card", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}