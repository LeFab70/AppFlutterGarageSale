import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/controllers/teams.provider.dart';
import 'package:test1_appgardienbut_fabrice/views/shared/widgets/teams/teams.list.dart';
import '../../models/teams.dart';
import '../shared/colors/colors.app.dart';

import '../shared/styles/app.style.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  // Clé pour le formulaire d'ajout
  final _formKey = GlobalKey<FormState>();

  //ici Country correspond au package country_picker.dart
  // Variables temporaires pour la création d'une équipe
  String _tempName = '';
  String _tempManager = '';
  String _tempLogo =
      'https://cdn-icons-png.flaticon.com/512/33/33736.png'; // Logo par défaut
  Country? _selectedCountry;

  void _showAddTeamModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        // Utilisation de StatefulBuilder pour mettre à jour le pays dans la modale
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Nouveau garage",
                    style: appStyle(20, AppColors.textColor, FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Nom de l'équipe
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nom du garage",
                      prefixIcon: Icon(Icons.shield),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Requis" : null,
                    onSaved: (val) => _tempName = val!,
                  ),

                  // Nom du Manager
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Manager",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Requis" : null,
                    onSaved: (val) => _tempManager = val!,
                  ),

                  const SizedBox(height: 10),
                  // URL du Logo
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "URL du Logo (Optionnel)",
                      prefixIcon: Icon(Icons.link),
                      hintText: "https://exemple.com/logo.png",
                    ),
                    onSaved: (val) {
                      // Si l'utilisateur laisse vide, on garde le logo par défaut
                      if (val != null && val.isNotEmpty) {
                        _tempLogo = val;
                      } else {
                        _tempLogo =
                            'https://cdn-icons-png.flaticon.com/512/33/33736.png';
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // Sélecteur de Pays
                  ListTile(
                    leading: Text(
                      _selectedCountry?.flagEmoji ?? "🌍",
                      style: const TextStyle(fontSize: 25),
                    ),
                    title: Text(_selectedCountry?.name ?? "Choisir un pays"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (country) {
                          setModalState(() => _selectedCountry = country);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _selectedCountry != null) {
                          _formKey.currentState!.save();
                          setState(() {
                            Provider.of<TeamsProvider>(context,listen: false).addTeam(
                              Teams(
                                id: DateTime.now().toString(),
                                name: _tempName,
                                managerName: _tempManager,
                                urlLogo: _tempLogo,
                                country: _selectedCountry!,
                              ),
                            );
                            _selectedCountry = null; // Reset
                          });
                          Navigator.pop(context);
                        } else if (_selectedCountry == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Veuillez choisir un pays"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Ajouter le garage",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //on ecouter le provider pour avoir la liste des equipes
   TeamsProvider teamsProvider=Provider.of<TeamsProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mes garages',
                style: appStyle(30, AppColors.textColor, FontWeight.bold),
              ),
              IconButton(
                onPressed: _showAddTeamModal,
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        // Liste des équipes
        Expanded(
          child: TeamsList(teamsList: teamsProvider.teams, onDeleteFromParent:(index)=> teamsProvider.deleteTeam(index)),
        ),
      ],
    );
  }
}
