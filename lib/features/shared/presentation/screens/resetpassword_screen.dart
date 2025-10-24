import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive/screen_size.dart';
import '../widgets/reset_password_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: IconButton(onPressed: (){
           context.go('/login');
        }, icon: Icon(Icons.arrow_back_ios_sharp)),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Reset Your Password",style: TextStyle(fontSize: getResponsiveFontSize(30)),),
              SizedBox(height: getResponsiveFontSize(40),),
              ResetPasswordWidget(),
            ],
          ),
        ),
    );
  }
}
