import 'package:test1_appgardienbut_fabrice/views/shared/colors/colors.app.dart';

import 'bottom.nav.widget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SafeAreaWidget extends StatelessWidget {
  final Function(int) changedIndex;
  final int currentIndex;
  const SafeAreaWidget({super.key, required this.changedIndex, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Expanded(
              child: BottomNavWidget(
                icon: Ionicons.analytics_outline,
                onTap: () => changedIndex(0),
                color: AppColors.buttonTextColor,
                activeColor: AppColors.buttonBackground,
                isActive: currentIndex == 0,
                label: 'Stats',
              ),
            ),
            Expanded(
              child: BottomNavWidget(
                icon: Ionicons.home_sharp,
                onTap: () => changedIndex(1),
                color: AppColors.buttonTextColor,
                activeColor: AppColors.buttonBackground,
                isActive: currentIndex == 1,
                label: 'Garages',
              ),
            ),


            const SizedBox(width: 48), //
            Expanded(
              child: BottomNavWidget(
                icon: Ionicons.heart_sharp,
                onTap: () => changedIndex(2),
                color: AppColors.buttonTextColor,
                activeColor: AppColors.buttonBackground,
                isActive: currentIndex == 2,
                label: 'Favoris',
              ),
            ),
            Expanded(
              child: BottomNavWidget(
                icon: Ionicons.person_circle_sharp,
                onTap: () => changedIndex(3),
                color: AppColors.buttonTextColor,
                activeColor: AppColors.buttonBackground,
                isActive: currentIndex == 3,
                label: 'Profile',
              ),
            ),
          ],
        )
        ),
      );

  }
}