import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/promo_model.dart';

/// Wrapper untuk SharedPreferences — menangani semua operasi local storage
class LocalStorage {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyCurrentUser = 'current_user';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyOrders = 'orders';
  static const String _keyFavorites = 'favorites';
  static const String _keyUsers = 'users';
  static const String _keyPromos = 'promos';
  static const String _keyProducts = 'products';

  // =============================================
  // AUTENTIKASI
  // =============================================

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyCurrentUser);
    if (userJson == null) return null;
    try {
      return UserModel.fromMap(jsonDecode(userJson));
    } catch (_) {
      return null;
    }
  }

  static Future<void> setCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUser, jsonEncode(user.toMap()));
  }

  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // =============================================
  // ONBOARDING
  // =============================================

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  static Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, value);
  }

  // =============================================
  // PESANAN
  // =============================================

  static Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_keyOrders);
    if (ordersJson == null) return [];
    try {
      final List<dynamic> list = jsonDecode(ordersJson);
      return list.map((item) => OrderModel.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(orders.map((o) => o.toMap()).toList());
    await prefs.setString(_keyOrders, json);
  }

  static Future<void> addOrder(OrderModel order) async {
    final orders = await getOrders();
    orders.insert(0, order); // Tambahkan di awal (terbaru dulu)
    await saveOrders(orders);
  }

  static Future<void> updateOrder(OrderModel updatedOrder) async {
    final orders = await getOrders();
    final index = orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
      await saveOrders(orders);
    }
  }

  // =============================================
  // FAVORIT
  // =============================================

  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }

  static Future<void> saveFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavorites, ids);
  }

  static Future<void> toggleFavorite(String productId) async {
    final ids = await getFavoriteIds();
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    await saveFavoriteIds(ids);
  }

  static Future<bool> isFavorite(String productId) async {
    final ids = await getFavoriteIds();
    return ids.contains(productId);
  }

  // =============================================
  // USERS (untuk registrasi baru)
  // =============================================

  static Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_keyUsers);
    if (usersJson == null) return [];
    try {
      final List<dynamic> list = jsonDecode(usersJson);
      return list.map((item) => UserModel.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsers, jsonEncode(users.map((u) => u.toMap()).toList()));
  }

  static Future<void> addUser(UserModel user) async {
    final users = await getUsers();
    users.add(user);
    await saveUsers(users);
  }

  // =============================================
  // PROMO
  // =============================================

  static Future<List<PromoModel>> getPromos() async {
    final prefs = await SharedPreferences.getInstance();
    final promosJson = prefs.getString(_keyPromos);
    if (promosJson == null) return [];
    try {
      final List<dynamic> list = jsonDecode(promosJson);
      return list.map((item) => PromoModel.fromMap(item)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> savePromos(List<PromoModel> promos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPromos, jsonEncode(promos.map((p) => p.toMap()).toList()));
  }

  // =============================================
  // PRODUK (untuk admin kelola produk)
  // =============================================

  static Future<List<Map<String, dynamic>>?> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString(_keyProducts);
    if (productsJson == null) return null;
    try {
      final List<dynamic> list = jsonDecode(productsJson);
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProducts, jsonEncode(products));
  }
}
