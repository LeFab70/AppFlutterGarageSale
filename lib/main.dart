import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/garage.provider.dart';
import 'controllers/login.provider.dart';
import 'controllers/main.screen.provider.dart';
import 'controllers/sale.provider.dart';
import 'root/app.garage.entry.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(

    //integration firebase
    //Mise en place du provider pour gerer le changement de pages depuis le bottomNavigationBar
    MultiProvider(
      providers: [
        //provider pour changer de pages a afficher
        ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
        // Provider pour la connexion
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        //provider pour gerer les garages
        ChangeNotifierProvider(create: (_) => GarageProvider()),
        //provider pour gerer les sales
        ChangeNotifierProvider(create: (_) => SaleProvider()),


      ],
      child: const AppGarageEntry(),
    ),
  );
}


