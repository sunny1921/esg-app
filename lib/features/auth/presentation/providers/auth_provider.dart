import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esg_post_office/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:esg_post_office/features/auth/domain/models/user_model.dart';
import 'package:esg_post_office/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String mobile,
    required String postOfficeId,
    required String pincode,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authRepository.signUp(
        name: name,
        email: email,
        mobile: mobile,
        postOfficeId: postOfficeId,
        pincode: pincode,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required bool isEmployee,
    String? employeeRole,
    String? gender,
    bool? isPhysicallyChallenged,
    String? casteCategory,
    String? employmentType,
    String? vendorName,
    List<String>? responsibilities,
  }) async {
    try {
      state = const AsyncValue.loading();
      await _authRepository.updateUserProfile(
        userId: userId,
        isEmployee: isEmployee,
        employeeRole: employeeRole,
        gender: gender,
        isPhysicallyChallenged: isPhysicallyChallenged,
        casteCategory: casteCategory,
        employmentType: employmentType,
        vendorName: vendorName,
        responsibilities: responsibilities,
      );
      final user = await _authRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
