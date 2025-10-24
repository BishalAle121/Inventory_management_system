import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors_manager.dart';
import '../../../../core/utils/custom_widgets/user_input_field_widget/search_text_form_field_widget.dart';
import '../../../shared/components/notification_component.dart';
import '../widgets/no_installation_today_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controllerSearchTodayInstallation = TextEditingController();
    return Scaffold(
      backgroundColor: kSmokyGrey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimary,
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text('Inventory Management', style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16, bottom: 30),
            child: NotificationComponent(
            ),
          ),
        ],
        toolbarHeight: 60,
      ),
      body: const NoInstallationTodayWidget(),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: 110,
            left: 30,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      blurRadius: 6,                        // Spread of shadow
                      offset: const Offset(0, 3),           // Shadow direction: down
                    ),
                  ],
                ),
                child: CustomSearchTextFormFieldWidget(
                  controller: controllerSearchTodayInstallation,
                  hintText: "Search Eg. Project Name",
                  prefixIcon: Icons.search,
                  iconSize: 28,
                )
            ),
          )


        ],
      ),
    );
  }
}