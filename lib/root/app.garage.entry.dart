import 'package:flutter/material.dart';
import '../views/ui/login.page.dart';
import '../controllers/login.provider.dart';
import '../views/ui/main.screen.dart';
import '../views/shared/colors/colors.app.dart';
import 'package:provider/provider.dart';

class AppGarageEntry extends StatelessWidget {
  const AppGarageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldColor,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: AppColors.primary,
              iconSize: 50,
              elevation: 5,
              foregroundColor: AppColors.buttonTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            bottomAppBarTheme: BottomAppBarThemeData(
              shape: const CircularNotchedRectangle(),
              color: AppColors.bottomNavColors,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.buttonTextColor,
              actionsPadding: const EdgeInsets.symmetric(horizontal: 6),
            ),
          ),
          // Home qui change automatiquement selon le login
          home: loginProvider.isLoading
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : loginProvider.isLoggedIn
                  ? MainScreen()
                  : const LoginPage(),
        );
      },
    );
  }
}