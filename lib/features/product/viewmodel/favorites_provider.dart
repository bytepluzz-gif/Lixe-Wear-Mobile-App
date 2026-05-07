import 'package:flutter/material.dart';
import '../model/product.dart';
import '../../../core/firestore_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final List<String> _favoriteIds = [];
  String? _uid;

  List<String> get favoriteIds => _favoriteIds;

  void attachUser(String uid) {
    _uid = uid;
    _service.favoriteIdsStream(uid).listen((ids) {
      _favoriteIds
        ..clear()
        ..addAll(ids);
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(Product product) async {
    final uid = _uid;
    if (uid == null) return;
    await _service.toggleFavorite(uid, product);
  }

  bool isFavorite(Product product) {
    return _favoriteIds.contains(product.id);
  }
}
