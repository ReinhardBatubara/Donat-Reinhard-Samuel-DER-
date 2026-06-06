import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../data/local_storage.dart';
import '../models/user_model.dart';

/// State untuk autentikasi
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isLoggedIn => user != null;
  bool get isAdmin => user?.isAdmin ?? false;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier untuk mengelola state autentikasi
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  /// Cek status login saat aplikasi dibuka
  Future<void> _init() async {
    final isLoggedIn = await LocalStorage.isLoggedIn();
    if (isLoggedIn) {
      final user = await LocalStorage.getCurrentUser();
      if (user != null) {
        state = state.copyWith(user: user);
      }
    }
  }

  /// Login dengan email dan password
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 800)); // Simulasi loading

    // Cek di dummy data
    final allUsers = [...DummyData.users];

    // Tambahkan user yang sudah register
    final savedUsers = await LocalStorage.getUsers();
    allUsers.addAll(savedUsers);

    try {
      final user = allUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      );

      await LocalStorage.setCurrentUser(user);
      await LocalStorage.setLoggedIn(true);

      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email atau kata sandi salah. Coba lagi.',
      );
      return false;
    }
  }

  /// Register akun baru
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 800));

    // Cek apakah email sudah terdaftar
    final allUsers = [...DummyData.users, ...await LocalStorage.getUsers()];
    final exists = allUsers.any((u) => u.email.toLowerCase() == email.toLowerCase());

    if (exists) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email sudah terdaftar. Gunakan email lain.',
      );
      return false;
    }

    final newUser = UserModel(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
      phone: phone,
      address: '',
      role: 'customer',
    );

    await LocalStorage.addUser(newUser);
    await LocalStorage.setCurrentUser(newUser);
    await LocalStorage.setLoggedIn(true);

    state = state.copyWith(user: newUser, isLoading: false);
    return true;
  }

  /// Update data profil pengguna
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      name: name,
      phone: phone,
      address: address,
    );

    await LocalStorage.setCurrentUser(updatedUser);
    state = state.copyWith(user: updatedUser);
  }

  /// Logout
  Future<void> logout() async {
    await LocalStorage.clearCurrentUser();
    state = const AuthState();
  }

  /// Hapus error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider utama auth
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
