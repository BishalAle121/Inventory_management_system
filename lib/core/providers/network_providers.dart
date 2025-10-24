


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:inventorymanagement/core/providers/storage_providers.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';
import '../../features/change_password/data/change_password_repository/change_password_repository.dart';
import '../../features/change_password/domain/I_change_password_reopsitory/i_change_password_repository.dart';
import '../../features/forgot_password/data/forget_password_repository.dart';
import '../../features/forgot_password/domain/i_ForgetPassword_repository.dart';
import '../../features/register/data/repositories/registration_repository.dart';
import '../../features/register/domain/repositories/I_regist_repository.dart';
import '../network/dio_client.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    ref.watch(dioClientProvider),
    ref.watch(tokenServiceProvider),
  );
});
final internetCheckerProvider = Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(tokenServiceProvider));
});

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(internetCheckerProvider).onStatusChange.map(
    (status) => status == InternetConnectionStatus.connected,
  );
});

final registrationRepositoryProvider = Provider<IRegistRepository>((ref) {
  return RegistrationRepository(ref.watch(dioClientProvider));
});

final forgetPasswordRepositoryProvider = Provider<IForgetPasswordRepository>((ref) {
  return ForgetPasswordRepository(ref.watch(dioClientProvider));
});

final changePasswordRepositoryProvider = Provider<IChangePasswordRepository>((ref){
   return ChangePasswordRepository(ref.watch(dioClientProvider),  ref.watch(tokenServiceProvider),);
});
