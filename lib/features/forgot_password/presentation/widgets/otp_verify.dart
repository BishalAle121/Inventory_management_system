import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/storage_constants.dart';
import '../../../../core/providers/storage_providers.dart';
import '../../../../core/utils/responsive/screen_size.dart';
import '../../application/providers/forgetpassword_provider.dart';

class OTPVerifyWidget extends ConsumerStatefulWidget {
  const OTPVerifyWidget({super.key});

  @override
  ConsumerState<OTPVerifyWidget> createState() => _OTPVerifyWidgetState();
}

class _OTPVerifyWidgetState extends ConsumerState<OTPVerifyWidget> {
  Color _borderColor = const Color(0xFF512DA8);
  final TextEditingController newTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final modeOfForgetPassword = ref
        .watch(preferenceManagerSingleValuePareProvider)
        .getString('forgetEmailOrNumber') ??
        'your email/phone';

    final notifier = ref.read(forgotPasswordProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Code Verification",
            style: TextStyle(
              fontSize: getResponsiveFontSize(30),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            "Enter the OTP sent to $modeOfForgetPassword",
            style: TextStyle(fontSize: getResponsiveFontSize(18)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120),
          PinCodeTextField(
            controller: newTextEditingController,
            animationType: AnimationType.fade,
            appContext: context,
            length: 6,
            keyboardType: TextInputType.number,
            enableActiveFill: true,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 70,
              fieldWidth: 46,
              activeFillColor: Colors.purple,
              selectedFillColor: Colors.orangeAccent,
              inactiveFillColor: Colors.grey,
              selectedColor: Colors.blueAccent,
              inactiveColor: Colors.grey,
            ),
            onChanged: (value) async {
              final forgetModeStore = ref
                  .read(preferenceManagerSingleValuePareProvider)
                  .getString(StorageConstants.userEmail);

              if (value.length < 6) return;

              if (forgetModeStore != null && value.length == 6) {
                print("Store Email ID: $forgetModeStore");
                print("OTP entered: $value");

                final otpVerifyStatus = await notifier.verifyOtp(forgetModeStore, value);

                print("Response OTP Verification: $otpVerifyStatus");

                // Check if the response contains your expected success message
                if (otpVerifyStatus.toString().toLowerCase().contains("success")) {
                  context.go('/ResetPasswordScreen');
                } else {
                  print("OTP verification failed or wrong OTP.");
                }
              }
            }
            ,
            onCompleted: (value) {
              setState(() {
                // otpValue = value;
              });

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Successfully Verified"),
                    content: Text('Code entered is $value'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      )
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
    );
  }
}





/*

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_clean_arch/core/providers/storage_providers.dart';

import '../../../../core/utils/responsive/screen_size.dart'; // Replace with actual path

Widget OPTVerify(BuildContext context, Ref ref) {

    Color _borderColor = const Color(0xFF512DA8);

    var modeOfForgetPassword = ref.watch(preferenceManagerSingleValuePareProvider).getString('forgetEmailOrNumber');
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Code Verification",
          style: TextStyle(
            fontSize: getResponsiveFontSize(30),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Enter the OTP sent to ${modeOfForgetPassword}",
          style: TextStyle(fontSize: getResponsiveFontSize(18)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 120),
        OtpTextField(
          numberOfFields: 6,
          borderColor: _borderColor,
          showFieldAsBox: true,
          fieldWidth: 50,
          focusedBorderColor: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8),
          textStyle: TextStyle(fontSize: getResponsiveFontSize(20)),
          onCodeChanged: (String code) {
            _borderColor = code.trim().isNotEmpty? Colors.green : Colors.deepPurple;
          },
          onSubmit: (String verificationCode) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Successfully Verified"),
                  content: Text('Code entered is $verificationCode'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    )
                  ],

                );
              },
            );
          },
        ),
      ],
    ),
  );
}




import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';


class OTPVerifyWidget extends StatefulWidget {
  const OTPVerifyWidget({Key? key}) : super(key: key);

  @override
  State<OTPVerifyWidget> createState() => _OTPVerifyWidgetState();
}

class _OTPVerifyWidgetState extends State<OTPVerifyWidget> {
  Color _borderColor = const Color(0xFF512DA8); // Default purple

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Code Verification",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Enter the OTP sent to bishalmanger121@gmail.com",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          OtpTextField(
            numberOfFields: 5,
            borderColor: _borderColor,
            showFieldAsBox: true,
            fieldWidth: 50,
            focusedBorderColor: Colors.deepPurple,
            borderRadius: BorderRadius.circular(8),
            textStyle: const TextStyle(fontSize: 20),
            onCodeChanged: (String code) {
              // Change to green if code is not empty
              setState(() {
                _borderColor = code.trim().isNotEmpty ? Colors.green : const Color(0xFF512DA8);
              });
            },
            onSubmit: (String verificationCode) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Successfully Verified"),
                    content: Text('Code entered is $verificationCode'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

*/
