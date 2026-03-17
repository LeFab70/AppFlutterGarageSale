import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/views/shared/widgets/logo.widget.dart';
import 'package:test1_appgardienbut_fabrice/views/shared/widgets/textfield.widget.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/main.screen.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/signup.screen.dart';
import '../../controllers/login.provider.dart';
import '../shared/colors/colors.app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();



  void _login() async {
    final email = _emailTextController.text.trim();
    final password = _passwordTextController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Tous les champs doivent être remplis.");
      return;
    }

    try {
      String? error = await Provider.of<LoginProvider>(context, listen: false)
          .login(email: email, password: password);

      if (!mounted) return;

      if (error != null) {
        debugPrint("error $error");
        _showMessage(error);
      } else {
        _showMessage("Connexion réussie !", isSuccess: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }

    } catch (e) {
      if (!mounted) return;
      _showMessage("Erreur lors de la connexion.");
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor:
        isSuccess ? Colors.green.shade400 : Colors.red.shade400,
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
              AppColors.secondary,
              AppColors.backgroundApp,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: [
                //utilisation des widgets decomposés
                Center(child: logoWidget("assets/images/salegarage.jpg")),
                SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      myTextField(
                        "Nom utilisateur",
                        Ionicons.person_circle_sharp,
                        false,
                        _emailTextController,
                      ),

                      const SizedBox(height: 20),

                      myTextField(
                        "Mot de passe",
                        Ionicons.lock_closed,
                        true,
                        _passwordTextController,
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {},
                              child: const Text("Mot de passe oublié ?"),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signup(),
                                  ),
                                );
                              },
                              child: const Text("Pas de compte ? Créer en un"),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      // // Bouton pour se connecter
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: context.watch<LoginProvider>().isLoading ? null : _login,
                        child: Row(
                          mainAxisAlignment: .spaceAround,
                          crossAxisAlignment: .center,
                          children: [
                            Icon(
                              Ionicons.log_in_outline,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              "Se connecter",
                              style: TextStyle(
                                color: AppColors.buttonTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
