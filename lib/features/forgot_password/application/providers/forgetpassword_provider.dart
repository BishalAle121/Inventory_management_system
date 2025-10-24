import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/network_providers.dart';
import '../../domain/i_ForgetPassword_repository.dart';

final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordNotifier, AsyncValue<String>>((ref) {
  final repo = ref.watch(forgetPasswordRepositoryProvider);
  return ForgotPasswordNotifier(repo);
});

class ForgotPasswordNotifier extends StateNotifier<AsyncValue<String>> {
  final IForgetPasswordRepository _repository;

  ForgotPasswordNotifier(this._repository) : super(const AsyncValue.data(''));

  Future<dynamic> sendOtp(String receptor) async {
    state = const AsyncValue.loading();
    final result = await _repository.sendOtp(receptor);
    return result.fold(
          (err) {
        state = AsyncValue.error(err, StackTrace.current);
        return err.message;
      },
          (message) {
        // state = AsyncValue.data(message);
        return message;
      },
    );
  }

  Future<dynamic> verifyOtp(String receptor, String otp) async {
    state = const AsyncValue.loading();
    final result = await _repository.verifyOtp(receptor, otp);
    return result.fold(
          (err) {
        state = AsyncValue.error(err, StackTrace.current);
        return err.message;
      },
          (message) {
        // state = AsyncValue.data(message);
            print("Main Return Provider: ${message}");
        return message;
      },
    );
  }

  Future<dynamic> resetPassword(String receptor, String newPassword) async {
    state = const AsyncValue.loading();
    final result = await _repository.resetPassword(receptor, newPassword);
    return result.fold(
          (err) {
        state = AsyncValue.error(err, StackTrace.current);
        return err.message;
      },
          (message) {
        // state = AsyncValue.data(message);
        return message;
      },
    );
  }
}

/*


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/network_providers.dart';
import '../../domain/i_forgetPassword_repository.dart';

final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(forgetPasswordRepositoryProvider); // Assuming authRepositoryProvider already exists
  return ForgotPasswordNotifier(repo);
});

class ForgotPasswordNotifier extends StateNotifier<AsyncValue<void>> {
  final IForgetPasswordRepository _repository;

  ForgotPasswordNotifier(this._repository) : super(AsyncData(null));

  Future<void> sendOtp(String receptor) async {
    state = const AsyncLoading();
    final result = await _repository.sendOtp(receptor);
    state = result.fold(
          (err) => AsyncError(err, StackTrace.current),
          (_) => AsyncData(null),
    );
  }
  Future<void> verifyOtp(String receptor, String otp) async {
    state = const AsyncLoading();
    final result = await _repository.verifyOtp(receptor, otp);
    state = result.fold(
          (err) => AsyncError(err, StackTrace.current),
          (_) => const AsyncData(null),
    );
  }

  Future<void> resetPassword(String receptor, String newPassword) async {
    state = const AsyncLoading();
    final result = await _repository.resetPassword(receptor, newPassword);
    state = result.fold(
          (err) => AsyncError(err, StackTrace.current),
          (_) => const AsyncData(null),
    );
  }
}
*/
