import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> products() =>
      firestore.collection('products');

  static DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      firestore.collection('users').doc(uid);

  static CollectionReference<Map<String, dynamic>> userFavorites(String uid) =>
      userDoc(uid).collection('favorites');

  static CollectionReference<Map<String, dynamic>> userCart(String uid) =>
      userDoc(uid).collection('cart');

  static CollectionReference<Map<String, dynamic>> userOrders(String uid) =>
      userDoc(uid).collection('orders');

  static CollectionReference<Map<String, dynamic>> userNotifications(
    String uid,
  ) => userDoc(uid).collection('notifications');

  static CollectionReference<Map<String, dynamic>> userAddresses(String uid) =>
      userDoc(uid).collection('addresses');

  static CollectionReference<Map<String, dynamic>> userCards(String uid) =>
      userDoc(uid).collection('cards');
}
