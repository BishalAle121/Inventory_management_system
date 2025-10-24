import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/storage_constants.dart';
import '../../../../core/providers/storage_providers.dart';
import '../../../../core/utils/components/UserInput/custom_textformfield.dart';
import '../../../../core/utils/components/submit_button/submit_btn.dart';
import '../../../change_password/application/provider/changepassword_provider.dart';
import '../../../change_password/data/model/changepassword_model.dart';
import '../../../forgot_password/application/providers/forgetpassword_provider.dart';

class ResetPasswordWidget extends ConsumerStatefulWidget {
  const ResetPasswordWidget({super.key});

  @override
  ConsumerState<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends ConsumerState<ResetPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  var userID;
  var emailID;

  @override
  Widget build(BuildContext context) {
    var sharePreferenceProvider =  ref.watch(preferenceManagerSingleValuePareProvider);
          userID = sharePreferenceProvider.getString(StorageConstants.userId);
          emailID = sharePreferenceProvider.getString(StorageConstants.userEmail);
    return Form(
      key: _formKey,
      child: Column(
        children: [

          if(userID != null)
          CustomTextFormField(
            label: "Old Password",
            hintText: "Enter Old Password",
            prefixIcon: Icons.lock_clock_outlined,
            suffixIcon: Icons.visibility_off,
            customController: _oldPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Old Password";
              }
              return null;
            },
          ),
          SizedBox(height: 20,),
          CustomTextFormField(
            label: "New Password",
            hintText: "Enter New Password",
            prefixIcon: Icons.lock_clock_outlined,
            suffixIcon: Icons.visibility_off,
            customController: _newPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter New Password";
              }
              return null;
            },
          ),
          SizedBox(height: 20,),
          CustomTextFormField(
            label: "Confirm Password",
            hintText: "Enter Confirm Password",
            prefixIcon: Icons.lock_clock_outlined,
            suffixIcon: Icons.visibility_off,
            customController: _confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Confirm Password";
              }
              return null;
            },
          ),
          SizedBox(height: 40,),
          CustomSubmitButton(
            label: userID != null? "Change Password" : "Reset",
            onPressed: () async{
              if (_formKey.currentState?.validate() ?? false) {

                if(userID != null)
                  {
                    var sendData = ChangePasswordModel(
                        UserEmailIDM: emailID,
                        UserOldPasswordM: _oldPasswordController.text,
                        UserNewPasswordM: _newPasswordController.text
                    );
                     final changePasswordStatus = await ref.read(changePasswordProvider.notifier).changePassword(sendData);
                     if(changePasswordStatus.contains("Change Password Successfully"))
                       {
                         ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(changePasswordStatus))
                         );
                         context.go('/home');
                       }
                     else
                       {
                         ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(changePasswordStatus))
                         );
                       }
                  }
                else
                  {
                    final passwordResetStatus = await ref.read(forgotPasswordProvider.notifier).resetPassword(emailID, _newPasswordController.text);
                    if(passwordResetStatus.contains("Password reset successfully."))
                    {
                      context.go('/login');
                    }
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}
