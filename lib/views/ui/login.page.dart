import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/styles/app.style.dart';
import '../../controllers/login.provider.dart';
import '../shared/colors/colors.app.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.backgroundApp,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.backgroundApp,
              AppColors.backgroundLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height*0.2,20 ,0),
            child:
              const Text("", style: TextStyle(fontSize: 80)),

          ),
        ),
      ),
    );
  }
}


// // Bouton pour se connecter
// ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: AppColors.buttonBackground,
// minimumSize: const Size(double.infinity, 55),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// ),
// onPressed: () {
// // On déclenche la connexion
// Provider.of<LoginProvider>(context, listen: false).login();
// },
// child: Text(
// "Se connecter",
// style: TextStyle(
// color: AppColors.buttonTextColor,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
//