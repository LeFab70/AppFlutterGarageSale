import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../../controllers/login.provider.dart';
import '../colors/colors.app.dart';
import '../styles/app.style.dart';

class AppBars extends StatelessWidget implements PreferredSize {
  final VoidCallback onPressed;

  const AppBars({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100.00,
      title: Text("🏡 + ✨ Garage sale",style: appStyle(25, AppColors.buttonTextColor, .bold)),
      actions: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(Ionicons.stats_chart, size: 20),
        ),
        IconButton(
          onPressed: () {
            // Déclenche la déconnexion
            Provider.of<LoginProvider>(context, listen: false).logout();
          },
          icon: Icon(Ionicons.exit_outline, size: 20),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.00);

  @override
  
  Widget get child => throw UnimplementedError();
}
