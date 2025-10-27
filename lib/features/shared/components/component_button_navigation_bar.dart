import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventorymanagement/core/constants/colors_manager.dart';

import '../providers/bottomnavnotifier.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavProvider);
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (i) {
        ref.read(bottomNavProvider.notifier).setIndex(i);
        switch (i) {
          case 0:
            // GoRouter.of(context).go('/home');
            GoRouter.of(context).go('/installation');
            break;
          case 1:
            GoRouter.of(context).go('/stock-in-out');
            break;
          case 2:
            GoRouter.of(context).go('/installation');
            break;
          case 3:
            GoRouter.of(context).go('/history');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 50,
            color: index == 0 ? kPrimary : Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            index == 1
                ? "assets/button_navigation_bar_icons/stock_in_and_out_color.png"
                : "assets/button_navigation_bar_icons/stock_in_and_out.png",
          ),
          label: 'Stock In/Out',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            index == 2
                ? "assets/button_navigation_bar_icons/installation_color.png"
                : "assets/button_navigation_bar_icons/installation.png",
          ),
          label: 'Installation',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            index == 3
                ? "assets/button_navigation_bar_icons/installation_history_color.png"
                : "assets/button_navigation_bar_icons/installation_history.png",
          ),
          label: 'All History',
        ),
      ],
    );
  }
}
