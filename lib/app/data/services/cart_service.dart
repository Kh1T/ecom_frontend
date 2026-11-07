import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/cart/controllers/cart_controller.dart';
import '../../modules/products/controllers/products_controller.dart';

/// Persistent cart storage backed by [SharedPreferences] (localStorage on Web).
class CartService extends GetxService {
  static const String _cartKey = 'cart_items';

  SharedPreferences? _prefs;

  Future<CartService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('CartService: SharedPreferences failed: $e');
    }
    return this;
  }

  Future<List<CartItem>> getCartItems() async {
    final raw = _prefs?.getString(_cartKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_cartItemFromJson)
          .whereType<CartItem>()
          .toList();
    } catch (e) {
      debugPrint('CartService: failed to decode cart: $e');
      return [];
    }
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    final encoded = jsonEncode(items.map(_cartItemToJson).toList());
    await _prefs?.setString(_cartKey, encoded);
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final items = await getCartItems();
    final index = items.indexWhere((i) => i.product.id == product.id);

    if (index != -1) {
      items[index].quantity.value += quantity;
    } else {
      final color = _defaultColorFor(product.name);
      items.add(
        CartItem(
          id: product.id,
          product: product,
          quantity: quantity.obs,
          colorName: _defaultColorNameFor(product.name),
          color: color,
          size: _defaultSizeFor(product.name),
        ),
      );
    }

    await saveCartItems(items);
  }

  Future<void> removeItem(int productId) async {
    final items = await getCartItems()..removeWhere((i) => i.product.id == productId);
    await saveCartItems(items);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity.value = quantity;
      }
      await saveCartItems(items);
    }
  }

  Future<void> clearCart() async {
    await _prefs?.remove(_cartKey);
  }

  Map<String, dynamic> _cartItemToJson(CartItem item) {
    return {
      'id': item.id,
      'product': item.product.toJson(),
      'quantity': item.quantity.value,
      'colorName': item.colorName,
      'color': item.color.toARGB32(),
      'size': item.size,
    };
  }

  CartItem? _cartItemFromJson(Map<String, dynamic> json) {
    try {
      final productJson = json['product'] as Map<String, dynamic>?;
      if (productJson == null) return null;

      return CartItem(
        id: (json['id'] as num?)?.toInt() ?? 0,
        product: Product.fromJson(productJson),
        quantity: ((json['quantity'] as num?)?.toInt() ?? 1).obs,
        colorName: json['colorName'] as String? ?? 'Default',
        color: Color(json['color'] as int? ?? Colors.black.toARGB32()),
        size: json['size'] as String? ?? 'Default',
      );
    } catch (e) {
      debugPrint('CartService: failed to parse cart item: $e');
      return null;
    }
  }

  static Color _defaultColorFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('green')) return const Color(0xFF556B2F);
    if (lower.contains('black')) return const Color(0xFF2F2F2F);
    if (lower.contains('blue')) return Colors.blue;
    if (lower.contains('red')) return Colors.red;
    return const Color(0xFF556B2F);
  }

  static String _defaultColorNameFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('green')) return 'Olive Green';
    if (lower.contains('black')) return 'Midnight Black';
    if (lower.contains('blue')) return 'Ocean Blue';
    if (lower.contains('red')) return 'Crimson Red';
    return 'Olive Green';
  }

  static String _defaultSizeFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('watch')) return '32 MM';
    return 'Default';
  }
}
