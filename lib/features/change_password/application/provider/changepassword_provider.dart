import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/network_providers.dart';
import '../../domain/I_change_password_reopsitory/i_change_password_repository.dart';
import '../state/change_password_state.dart';


final changePasswordProvider = StateNotifierProvider<ChangePasswordProvider, ChangePasswordState>((ref) {
   final repo = ref.read(changePasswordRepositoryProvider);
   return ChangePasswordProvider(repo);
});

class ChangePasswordProvider extends StateNotifier<ChangePasswordState> {
   final IChangePasswordRepository _changePasswordRepository;

   ChangePasswordProvider(this._changePasswordRepository)
       : super(const ChangePasswordInitial());

   Future<String> changePassword(entity) async {
      state = const ChangePasswordLoading();

      final result = await _changePasswordRepository.ChangePassword(entity);

      return result.fold(
             (failure) {
                state = ChangePasswordFailure(failure.message);
                return "Change Password Failed";
             },
             (message){
                state = ChangePasswordSuccess(message);
                return "Change Password Successfully";
             },
      );
   }
}
