import 'package:flutter/material.dart';

import '../../../../core/utils/responsive/screen_size.dart';

class NoInstallationTodayWidget extends StatelessWidget {
  const NoInstallationTodayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Center(child: Icon(Icons.note_alt_outlined, size: getProportionateScreenWidth(140),)),
           Text("No Installation Found",style: TextStyle(fontSize: getResponsiveFontSize(30),),)
      ],),
    );
  }
}
