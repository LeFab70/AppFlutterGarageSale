import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test1_appgardienbut_fabrice/views/shared/colors/colors.app.dart';
import '../shared/styles/app.style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final email = user?.email ?? "Email non disponible";
    final lastLogin = user?.metadata.lastSignInTime;
    final createdAt = user?.metadata.creationTime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: appStyle(24, AppColors.textColor, FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 🔹 Informations utilisateur
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: Text(
                email,
                style: appStyle(18, AppColors.textColor, FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "Dernière connexion : ${lastLogin != null ? "${lastLogin.day}/${lastLogin.month}/${lastLogin.year} à ${lastLogin.hour}h${lastLogin.minute.toString().padLeft(2, '0')}" : "Inconnue"}",
                    style: appStyle(13, AppColors.secondary, FontWeight.w400),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Compte créé le : ${createdAt != null ? "${createdAt.day}/${createdAt.month}/${createdAt.year}" : "Inconnu"}",
                    style: appStyle(13, AppColors.secondary, FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Mode sombre
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined,
                color: AppColors.buttonBackground,
              ),
              title: Text(
                'Mode Sombre',
                style: appStyle(18, AppColors.textColor, FontWeight.w500),
              ),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Déconnexion
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: Text(
                "Déconnexion",
                style: appStyle(18, AppColors.textColor, FontWeight.w500),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Supprimer mon compte
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(
                "Supprimer mon compte",
                style: appStyle(18, Colors.red, FontWeight.w600),
              ),
              onTap: () {
                _confirmDeleteAccount(context);
              },
            ),
          ),

          const Spacer(),

          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  "Author: Fabrice Kouonang",
                  style: appStyle(16, AppColors.textColor, FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Version 1.0.0 • CCNB-2026",
                  textAlign: TextAlign.center,
                  style: appStyle(12, Colors.grey, FontWeight.normal),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Confirmation avant suppression
  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer le compte"),
        content: const Text(
          "Cette action est irréversible. Voulez-vous vraiment supprimer votre compte ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ANNULER"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await FirebaseAuth.instance.currentUser!.delete();
                Navigator.pushReplacementNamed(context, "/login");
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Veuillez vous reconnecter avant de supprimer votre compte."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("SUPPRIMER", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
