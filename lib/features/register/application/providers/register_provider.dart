import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/network_providers.dart';
import '../../data/models/registration_model.dart';
import '../../domain/repositories/I_regist_repository.dart';
import '../states/regist_state.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref){
  final repository = ref.watch(registrationRepositoryProvider);
    return RegisterNotifier(repository);
});


class RegisterNotifier extends StateNotifier<RegisterState>
{
  final IRegistRepository _registRepository;

  RegisterNotifier(this._registRepository) : super(const RegisterInitial());

  Future<bool> newUserRegistration(RegistrationModel newUser) async
  {
      state = const RegisterLoading();

     final result = await _registRepository.registration(newUser);

    /* // Method 1
     state = result.fold(
         (error) => RegisterFailure(error.message),
         (success) => RegisterSuccess("User Successfully Register")
     );*/


      // Method 2
      return result.fold(
              (error) { state = RegisterFailure(error.message); return false;},
              (success) { state = RegisterSuccess("User Successfully Register"); return true;}
      );
  }
}