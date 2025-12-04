import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_client/core/models/user_model.dart';
import 'package:spotify_client/features/auth/model/auth_repository.dart';

// 1. Current User Notifier (Global User State)
// Holds the user data (Name, Email, Token) accessible app-wide.
final currentUserNotifierProvider =
    NotifierProvider<CurrentUserNotifier, UserModel?>(() {
      return CurrentUserNotifier();
    });

class CurrentUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    // Initial state is null (Not logged in)
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }
}

// 2. Auth View Model (Modern AsyncNotifier)
// Handles the Logic for Login, Signup, and Logout.
// Replaces StateNotifier, so no 'legacy.dart' is needed.
final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(() {
  return AuthViewModel();
});

class AuthViewModel extends AsyncNotifier<void> {
  // This replaces the constructor.
  // We return null (void) because we start in an "idle" state.
  @override
  Future<void> build() async {
    return;
  }

  // Check if token exists and fetch user data
  Future<void> getData() async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);

    // We don't use AsyncValue.guard here because we want to handle the null user gracefully
    try {
      final user = await authRepository.getCurrentUserData();
      if (user != null) {
        userNotifier.addUser(user);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Sign Up Logic
  Future<void> signupUser(String name, String email, String password) async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);

    // AsyncValue.guard automatically catches errors and sets state to AsyncValue.error
    state = await AsyncValue.guard(() async {
      await authRepository.signup(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  // Login Logic
  Future<void> loginUser(String email, String password) async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await authRepository.login(email: email, password: password);
      // Immediately fetch user data so the app switches to Home Page
      await getData();
    });
  }

  // Logout Logic
  void logoutUser() {
    final authRepository = ref.read(authRepositoryProvider);
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);

    authRepository.logout();
    userNotifier.removeUser(); // This triggers the Router to redirect to Login
  }
}
