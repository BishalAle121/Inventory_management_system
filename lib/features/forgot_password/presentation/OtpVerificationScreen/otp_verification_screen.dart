import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../widgets/otp_verify.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/login'), // fix path if needed
          icon: const Icon(Icons.arrow_back_ios, size: 30),
        ),
      ),
      body: OTPVerifyWidget(),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/otp_verify.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
          onPressed: () => context.go('login'),
          icon: Icon(Icons.arrow_back_ios, size: 30)
      ),),
      // body: OTPVerifyWidget(),
      body: OPTVerify(context, ref),
    );
  }
}*/
