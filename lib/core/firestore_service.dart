import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/product/model/product.dart';
import 'firebase_collections.dart';

class FirestoreService {
  Stream<List<Product>> productsStream() {
    return FirebaseCollections.products().snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<String>> favoriteIdsStream(String uid) {
    return FirebaseCollections.userFavorites(uid).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  Future<void> toggleFavorite(String uid, Product product) async {
    final ref = FirebaseCollections.userFavorites(uid).doc(product.id);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.delete();
      return;
    }
    await ref.set(product.toMap());
  }

  Stream<List<CartItem>> cartStream(String uid) {
    return FirebaseCollections.userCart(uid).snapshots().asyncMap((snapshot) async {
      final items = <CartItem>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final productId = data['productId'] as String? ?? '';
        if (productId.isEmpty) continue;
        final productDoc = await FirebaseCollections.products().doc(productId).get();
        if (!productDoc.exists) continue;
        final product = Product.fromMap(productDoc.id, productDoc.data()!);
        items.add(
          CartItem(
            product: product,
            size: data['size'] as String? ?? '',
            quantity: data['quantity'] as int? ?? 1,
          ),
        );
      }
      return items;
    });
  }

  Future<void> addToCart(String uid, Product product, String size) async {
    final ref = FirebaseCollections.userCart(uid).doc('${product.id}_$size');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final currentQty = snapshot.data()?['quantity'] as int? ?? 1;
      await ref.update({'quantity': currentQty + 1});
      return;
    }
    await ref.set({'productId': product.id, 'size': size, 'quantity': 1});
  }

  Future<void> updateCartQuantity(
    String uid,
    Product product,
    String size,
    int quantity,
  ) async {
    final ref = FirebaseCollections.userCart(uid).doc('${product.id}_$size');
    if (quantity <= 0) {
      await ref.delete();
      return;
    }
    await ref.update({'quantity': quantity});
  }

  Future<void> removeFromCart(String uid, Product product, String size) async {
    await FirebaseCollections.userCart(uid).doc('${product.id}_$size').delete();
  }

  Future<void> clearCart(String uid) async {
    final docs = await FirebaseCollections.userCart(uid).get();
    final batch = FirebaseCollections.firestore.batch();
    for (final doc in docs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> saveUserProfile(String uid, Map<String, dynamic> profile) async {
    await FirebaseCollections.userDoc(uid).set(profile, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userProfileStream(String uid) {
    return FirebaseCollections.userDoc(uid).snapshots();
  }

  Future<void> addAddress(String uid, Map<String, dynamic> address) async {
    await FirebaseCollections.userAddresses(uid).add(address);
  }

  /// Keeps a single selectable address for checkout (same line as profile).
  Future<void> setPrimaryAddress(String uid, String addressLine) async {
    await FirebaseCollections.userAddresses(uid).doc('primary').set({
      'label': 'Home',
      'address': addressLine,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateAddress(
    String uid,
    String addressId,
    Map<String, dynamic> address,
  ) async {
    await FirebaseCollections.userAddresses(uid).doc(addressId).update(address);
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    await FirebaseCollections.userAddresses(uid).doc(addressId).delete();
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> addressesStream(
    String uid,
  ) {
    return FirebaseCollections.userAddresses(uid).snapshots().map((s) => s.docs);
  }

  Future<void> addCard(String uid, Map<String, dynamic> card) async {
    await FirebaseCollections.userCards(uid).add(card);
  }

  Future<void> updateCard(
    String uid,
    String cardId,
    Map<String, dynamic> card,
  ) async {
    await FirebaseCollections.userCards(uid).doc(cardId).update(card);
  }

  Future<void> deleteCard(String uid, String cardId) async {
    await FirebaseCollections.userCards(uid).doc(cardId).delete();
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> cardsStream(
    String uid,
  ) {
    return FirebaseCollections.userCards(uid).snapshots().map((s) => s.docs);
  }

  Future<void> placeOrder(
    String uid, {
    required List<CartItem> cartItems,
    required double total,
    required String addressId,
    required String addressLabel,
    required String addressText,
    required String cardId,
    required String cardLast4,
    required String cardHolder,
  }) async {
    await FirebaseCollections.userOrders(uid).add({
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
      'shippingAddress': {
        'addressId': addressId,
        'label': addressLabel,
        'line': addressText,
      },
      'payment': {
        'cardId': cardId,
        'last4': cardLast4,
        'holder': cardHolder,
      },
      'items': cartItems
          .map(
            (item) => {
              'productId': item.product.id,
              'name': item.product.name,
              'price': item.product.price,
              'size': item.size,
              'quantity': item.quantity,
            },
          )
          .toList(),
    });
    await FirebaseCollections.userNotifications(uid).add({
      'title': 'Order placed',
      'message': 'Your order has been placed successfully.',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> ordersStream(
    String uid,
  ) {
    return FirebaseCollections.userOrders(
      uid,
    ).orderBy('createdAt', descending: true).snapshots().map((s) => s.docs);
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> notificationsStream(
    String uid,
  ) {
    return FirebaseCollections.userNotifications(
      uid,
    ).orderBy('createdAt', descending: true).snapshots().map((s) => s.docs);
  }
}
