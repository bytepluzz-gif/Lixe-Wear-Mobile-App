import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/firestore_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: uid == null
          ? const Center(child: Text('Please sign in'))
          : StreamBuilder(
              stream: context.read<FirestoreService>().ordersStream(uid),
              builder: (context, snapshot) {
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text('No orders yet'));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final data = orders[index].data();
                    return ListTile(
                      title: Text('Order #${orders[index].id.substring(0, 6)}'),
                      subtitle: Text('${(data['items'] as List?)?.length ?? 0} items'),
                      trailing: Text('\$${(data['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
                    );
                  },
                );
              },
            ),
    );
  }
}
