import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../data/local_storage.dart';
import '../models/promo_model.dart';

/// Notifier untuk promo
class PromoNotifier extends StateNotifier<List<PromoModel>> {
  PromoNotifier() : super([]) {
    _loadPromos();
  }

  Future<void> _loadPromos() async {
    final savedPromos = await LocalStorage.getPromos();
    if (savedPromos.isNotEmpty) {
      state = savedPromos;
    } else {
      state = DummyData.promos;
    }
  }

  /// Validasi kode promo
  PromoModel? validateCode(String code) {
    try {
      return state.firstWhere(
        (p) => p.code.toUpperCase() == code.toUpperCase() && p.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> addPromo(PromoModel promo) async {
    state = [...state, promo];
    await LocalStorage.savePromos(state);
  }

  Future<void> updatePromo(PromoModel updatedPromo) async {
    state = state.map((p) => p.code == updatedPromo.code ? updatedPromo : p).toList();
    await LocalStorage.savePromos(state);
  }

  Future<void> deletePromo(String code) async {
    state = state.where((p) => p.code != code).toList();
    await LocalStorage.savePromos(state);
  }

  Future<void> toggleActive(String code) async {
    state = state.map((p) {
      return p.code == code ? p.copyWith(isActive: !p.isActive) : p;
    }).toList();
    await LocalStorage.savePromos(state);
  }
}

final promoProvider = StateNotifierProvider<PromoNotifier, List<PromoModel>>((ref) {
  return PromoNotifier();
});

/// Provider untuk kode promo yang sedang dipakai di checkout
final selectedPromoProvider = StateProvider<PromoModel?>((ref) => null);
