import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../../../core/providers/network_providers.dart';
import '../../../../core/providers/storage_providers.dart';
import '../../../../core/utils/components/UserInput/text_field.dart';
import '../../../../core/utils/components/reusable_function/validation_fun.dart';
import '../../../../core/utils/components/submit_button/submit_btn.dart';
import '../../../../core/utils/responsive/screen_size.dart';
import '../../../forgot_password/application/providers/forgetpassword_provider.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/states/auth_state.dart';
import '../../../shared/presentation/widgets/custom_text_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgetPasswordEmailOrPhone = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );

      final authState = ref.read(authProvider); // re-read updated state

      if (authState is AuthAuthenticated) {
        final sharePreferenceManager = await ref.read(preferenceManagerSingleValuePareProvider);

         sharePreferenceManager.setString(StorageConstants.userId, authState.user.userID);
         sharePreferenceManager.setString(StorageConstants.userName, authState.user.userName!);
         sharePreferenceManager.setString(StorageConstants.userEmail, authState.user.userEmail);
         sharePreferenceManager.setString(StorageConstants.userPhoneNo, authState.user.userPhoneNumber);
         sharePreferenceManager.setString(StorageConstants.tokenExpiry, authState.user.userExpireToken);
         sharePreferenceManager.setString(StorageConstants.refreshToken, authState.user.userRefreshToken);
      }
    }
  }


  final GlobalKey<TextFieldCustomState> _emailFieldKey = GlobalKey<TextFieldCustomState>();



  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    SizeConfig.init(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Inventory Management',
              style: TextStyle(
                fontSize: getResponsiveFontSize(30),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              suffixIcon: Icon(Icons.email, size: getResponsiveFontSize(28)),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Email is required';
                }
                if (!value!.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off, size: getResponsiveFontSize(28),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Password is required';
                }
                if (value!.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            ElevatedButton(
              onPressed: authState is AuthLoading ? null : _handleLogin,
              child: authState is AuthLoading
                  ? SizedBox(
                      height: getProportionateScreenHeight(20),
                      width: getProportionateScreenWidth(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Login', style: TextStyle(fontSize: getResponsiveFontSize(16)),),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(16),
                  horizontal: getProportionateScreenWidth(32),
                ),
              ),),
            SizedBox(height: 20,),
            TextButton(
              onPressed: (){},
                child: Text('Forgot Password?', style: TextStyle(fontSize: getResponsiveFontSize(16))
                            ),
              ),
            TextButton(
              onPressed: () => context.pushReplacement('/register'),
              child: Text('Create an Account', style: TextStyle(fontSize: getResponsiveFontSize(16))),
            ),
            ],
            ),
      ));
  }
}