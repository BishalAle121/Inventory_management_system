import 'package:flutter/material.dart';
import 'package:inventorymanagement/core/constants/colors_manager.dart';

class NotificationComponent extends StatefulWidget {
  const NotificationComponent({super.key});

  @override
  State<NotificationComponent> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        // Notification icon
        Positioned(
          child: Icon(
            Icons.notifications_active_rounded,
            color: Colors.white,
            size: 45,
          ),
        ),

        Positioned(
          right: 1,
          top: 1,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: kNotification, // your custom color
            child: Text(
              "3", // example badge count
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

}
