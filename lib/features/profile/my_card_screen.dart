import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/firestore_service.dart';

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF042404),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Cards",
          style: TextStyle(
            color: Color(0xFF042404),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Builder(
          builder: (context) {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid == null) return const Text('Please sign in');
            return StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              stream: context.read<FirestoreService>().cardsStream(uid),
              builder: (context, snapshot) {
                final cards = snapshot.data ?? [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (cards.isEmpty) {
                  return Column(
                    children: [
                      const Text('No saved cards yet'),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/add-payment'),
                        child: const Text('Add Card'),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    ...cards.map(
                      (c) => ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text('**** **** **** ${c.data()['last4'] ?? ''}'),
                        subtitle: Text('Exp: ${c.data()['expiry'] ?? ''}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            await context.read<FirestoreService>().deleteCard(
                              uid,
                              c.id,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Card deleted')),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/add-payment'),
                      child: const Text('Add Card'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
