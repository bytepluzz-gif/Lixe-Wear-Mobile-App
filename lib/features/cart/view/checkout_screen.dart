import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodel/cart_provider.dart';
import '../../../core/firebase_collections.dart';
import '../../../core/firestore_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedAddressId;
  String? _selectedCardId;
  bool _placing = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final service = context.read<FirestoreService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: Navigator.canPop(context),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF042404),
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(
            color: const Color(0xFF042404),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: uid == null
          ? const Center(child: Text('Please sign in'))
          : cartProvider.cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your bag is empty',
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/product-listing');
                        },
                        child: const Text('Browse products'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildProgressStep(Icons.local_shipping, true),
                            _buildProgressDivider(),
                            _buildProgressStep(Icons.payment, true),
                            _buildProgressDivider(),
                            _buildProgressStep(Icons.check_circle_outline, false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shipping address",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/personal-info',
                            ),
                            child: Text(
                              "Edit in profile",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF4A7043),
                              ),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                        stream: service.addressesStream(uid),
                        builder: (context, snap) {
                          final docs = snap.data ?? [];
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (docs.isEmpty) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No saved address. Add one in Personal Information.',
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/personal-info',
                                      ),
                                      child: const Text('Add address'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: docs.map((d) {
                              final data = d.data();
                              final label =
                                  data['label'] as String? ?? 'Address';
                              final line =
                                  data['address'] as String? ?? '';
                              final selected = _selectedAddressId == d.id;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () => setState(
                                    () => _selectedAddressId = d.id,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFF042404)
                                            : Colors.grey.shade300,
                                        width: selected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          selected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: selected
                                              ? const Color(0xFF042404)
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                label,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                line,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment method",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/add-payment'),
                            child: Text(
                              "Add card",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF4A7043),
                              ),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                        stream: service.cardsStream(uid),
                        builder: (context, snap) {
                          final docs = snap.data ?? [];
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (docs.isEmpty) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No saved card. Add a payment method.',
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/add-payment',
                                      ),
                                      child: const Text('Add card'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: docs.map((d) {
                              final data = d.data();
                              final last4 = data['last4'] as String? ?? '';
                              final holder =
                                  data['holder'] as String? ?? 'Card';
                              final selected = _selectedCardId == d.id;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () =>
                                      setState(() => _selectedCardId = d.id),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFF042404)
                                            : Colors.grey.shade300,
                                        width: selected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          selected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: selected
                                              ? const Color(0xFF042404)
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '•••• $last4',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                holder,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      Text(
                        "Order summary",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            _summaryRow(
                              "Subtotal",
                              "\$${cartProvider.total.toStringAsFixed(2)}",
                            ),
                            const SizedBox(height: 12),
                            _summaryRow("Shipping", "Free"),
                            const Divider(height: 32),
                            _summaryRow(
                              "Total",
                              "\$${cartProvider.total.toStringAsFixed(2)}",
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _placing
                              ? null
                              : () => _placeOrder(
                                    context,
                                    service,
                                    cartProvider,
                                    uid,
                                  ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF042404),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _placing
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Place order",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }

  Future<void> _placeOrder(
    BuildContext context,
    FirestoreService service,
    CartProvider cartProvider,
    String uid,
  ) async {
    if (_selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a shipping address')),
      );
      return;
    }
    if (_selectedCardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a payment method')),
      );
      return;
    }

    final addrSnap = await FirebaseCollections.userAddresses(uid)
        .doc(_selectedAddressId!)
        .get();
    final cardSnap =
        await FirebaseCollections.userCards(uid).doc(_selectedCardId!).get();

    if (!addrSnap.exists || !cardSnap.exists) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refresh and select address & card again')),
      );
      return;
    }

    final addr = addrSnap.data()!;
    final card = cardSnap.data()!;

    try {
      setState(() => _placing = true);
      await service.placeOrder(
        uid,
        cartItems: cartProvider.cart,
        total: cartProvider.total,
        addressId: _selectedAddressId!,
        addressLabel: addr['label'] as String? ?? 'Address',
        addressText: addr['address'] as String? ?? '',
        cardId: _selectedCardId!,
        cardLast4: card['last4'] as String? ?? '',
        cardHolder: card['holder'] as String? ?? '',
      );
      await cartProvider.clearCart();
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4A7043),
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                "Order placed!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your order has been placed successfully.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: const Color(0xFF757575)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042404),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Back to home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not place order: $e')),
      );
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  Widget _buildProgressStep(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF042404) : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey[500],
        size: 20,
      ),
    );
  }

  Widget _buildProgressDivider() {
    return Container(width: 40, height: 2, color: Colors.grey[200]);
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isTotal ? const Color(0xFF042404) : const Color(0xFF757575),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isTotal ? const Color(0xFF4A7043) : const Color(0xFF042404),
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
