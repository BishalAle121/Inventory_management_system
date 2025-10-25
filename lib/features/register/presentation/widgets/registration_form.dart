import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/presentation/widgets/custom_text_field.dart';
import '../../application/providers/register_provider.dart';
import '../../data/models/registration_model.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({super.key});

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPhoneNumber = TextEditingController();
  TextEditingController _controllerEmailId = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerConfirmPassword = TextEditingController();

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  bool _isEmailConfirm = false;

  void _handleRegistration() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newUser = RegistrationModel(
        userName: _controllerUserName.text,
        phoneNumber: _controllerPhoneNumber.text,
        emailId: _controllerEmailId.text,
        confirmEmail: _isEmailConfirm,
        password: _controllerPassword.text,
      );
      bool registrationStatus = await ref
          .read(registerProvider.notifier)
          .newUserRegistration(newUser);
      if (registrationStatus) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Successfully Done"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Registration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          CustomTextField(
            label: "Username",
            controller: _controllerUserName,
            suffixIcon: Icon(Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter Username";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Phone Number",
            controller: _controllerPhoneNumber,
            suffixIcon: Icon(Icons.phone),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter Username";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Email Id",
            controller: _controllerEmailId,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter Email Id";
              }
              return null;
            },

            suffixIcon: Icon(Icons.email),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Password",
            controller: _controllerPassword,
            obscureText: _isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter Password";
              }
              return null;
            },

            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Confirm Password",
            controller: _controllerConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter Confirm Password";
              }
              if (_controllerPassword.text != _controllerConfirmPassword.text) {
                return "Confirm Password does not match";
              }
              _isEmailConfirm = true;
            },
            obscureText: _isConfirmPasswordVisible,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleRegistration,
            child: Text("Sign Up"),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(
                onPressed: () => context.pushReplacement('/login'),
                child: Text("Sign In"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
