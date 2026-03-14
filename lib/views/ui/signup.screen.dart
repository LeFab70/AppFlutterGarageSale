import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/login.page.dart';
import '../shared/widgets/textfield.widget.dart';
import '../shared/colors/colors.app.dart';
import '../../controllers/login.provider.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Cette expression vérifie la présence d'un @ et d'un domaine (ex: .com, .ca, .fr)
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final userName=_userNameController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || userName.isEmpty) {
      _showMessage("Tous les champs doivent être remplis.");
      return;
    }
    if (!_isEmailValid(email)) {
      _showMessage("Veuillez entrer une adresse e-mail valide.");
      return;
    }
    if (password != confirmPassword) {
      _showMessage("Les mots de passe ne correspondent pas.");
      return;
    }


    setState(() {
      _isLoading = true;
    });

    try {
      // service pour créer le compte
      // await Provider.of<LoginProvider>(context, listen: false)
      //     .signup(email, password);

      setState(() {
        _isLoading = false;
      });

      _showMessage("Compte créé avec succès !", isSuccess: true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessage("Erreur lors de la création du compte.");
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(fontSize: 15,fontWeight: .bold),),
        backgroundColor: isSuccess ? Colors.green : Colors.red.shade100,
        duration: const Duration(seconds: 5),
      ),
    );

    if (isSuccess) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              myTextField(
                "Nom utilisateur",
                Ionicons.person_circle_sharp,
                false,
                _userNameController,
              ),
              myTextField(
                "Email",
                Ionicons.mail_open_outline,
                false,
                _emailController,
              ),
              const SizedBox(height: 20),
              myTextField(
                "Mot de passe",
                Ionicons.lock_closed,
                true,
                _passwordController,
              ),
              const SizedBox(height: 20),
              myTextField(
                "Confirmer mot de passe",
                Ionicons.lock_closed,
                true,
                _confirmPasswordController,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _signup,
                child: const Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("Déjà un compte ? Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}