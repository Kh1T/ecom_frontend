import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent wishlist backed by [SharedPreferences].
///
/// Stores favorite product ids so the wishlist survives app restarts and is
/// shared across the home, search, and wishlist screens.
class WishlistService extends GetxService {
  static const String _key = 'wishlist_ids';

  SharedPreferences? _prefs;

  final favoriteIds = <int>{}.obs;

  Future<WishlistService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _load();
    } catch (e) {
      debugPrint('WishlistService: SharedPreferences failed: $e');
    }
    return this;
  }

  void _load() {
    final raw = _prefs?.getStringList(_key);
    if (raw == null) return;
    favoriteIds.assignAll(raw.map(int.tryParse).whereType<int>());
  }

  bool isFavorite(int productId) => favoriteIds.contains(productId);

  Future<void> toggle(int productId) async {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
    await _persist();
  }

  Future<void> remove(int productId) async {
    favoriteIds.remove(productId);
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setStringList(
      _key,
      favoriteIds.map((id) => '$id').toList(),
    );
  }
}
