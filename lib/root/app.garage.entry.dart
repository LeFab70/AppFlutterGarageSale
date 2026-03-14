import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/login.page.dart';
import '../controllers/login.provider.dart';
import '../views/ui/main.screen.dart';
import '../views/shared/colors/colors.app.dart';

class AppGarageEntry extends StatelessWidget {
  const AppGarageEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.buttonBackground,
          iconSize: 40,
          elevation: 4,
          foregroundColor: AppColors.buttonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
        bottomAppBarTheme: BottomAppBarThemeData(
          shape: const CircularNotchedRectangle(),
          color: AppColors.bottomNavColors,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.buttonTextColor,
          //centerTitle: true,
          actionsPadding: EdgeInsets.symmetric(horizontal: 6),

        )
      ),

      // On vérifie si l'utilisateur est connecté
     home:Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          if (loginProvider.isLoggedIn) {
            return MainScreen(); //afficher le mainscreen si connecté
          } else {
            return const LoginPage(); //  page de login
          }
        },
      ),
    );
  }
}
