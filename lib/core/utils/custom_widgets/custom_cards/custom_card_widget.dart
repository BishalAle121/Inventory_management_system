import 'package:flutter/material.dart';
import 'package:inventorymanagement/core/constants/colors_manager.dart';

class CustomCardWidget extends StatelessWidget {
   final Widget child;
   const CustomCardWidget({required this.child, Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
      return Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
            decoration: BoxDecoration(
               color: kWhite,
               borderRadius: BorderRadius.circular(0),
               boxShadow: [
                  BoxShadow(
                     color: Colors.black.withOpacity(0.3), // shadow color
                     offset: const Offset(0, 6), // only bottom shadow (x=0, y=6)
                     blurRadius: 8, // softens the shadow
                     spreadRadius: 1, // makes shadow bigger
                  ),
               ],
            ),
            child: child
         ),
      );
   }
}
