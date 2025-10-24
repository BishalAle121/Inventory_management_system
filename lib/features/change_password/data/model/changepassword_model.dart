

import '../../domain/entities/change_password.dart';

class ChangePasswordModel extends ChangePassword
{
   final String UserEmailIDM;
   final String UserOldPasswordM;
   final String UserNewPasswordM;

   ChangePasswordModel(
       {
         required this.UserEmailIDM,
         required this.UserOldPasswordM,
         required this.UserNewPasswordM
       }) : super(
     UserEmailID: UserEmailIDM,
     UserOldPassword: UserOldPasswordM,
     UserNewPassword: UserNewPasswordM
   );
   factory ChangePasswordModel.fromEntity(ChangePassword entity) {
     return ChangePasswordModel(
       UserEmailIDM: entity.UserEmailID,
       UserOldPasswordM: entity.UserOldPassword,
       UserNewPasswordM: entity.UserNewPassword,
     );
   }


   Map<String, dynamic> toJson()
   {
       return{
         'UserEmail' : UserEmailIDM,
         'OldPassword' : UserOldPasswordM,
         'NewPassword' : UserNewPasswordM
       };
   }
}