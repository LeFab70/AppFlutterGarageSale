import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/controllers/garage.provider.dart';
import '../../models/garage.dart';
import '../shared/colors/colors.app.dart';
import '../shared/styles/app.style.dart';
import '../shared/widgets/garages/garage.list.dart';



class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  final _formKey = GlobalKey<FormState>();

  String _tempName = '';
  String _tempManager = '';
  String _tempCity = '';
  String _tempZipcode = '';

  void _showAddGarageModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
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

                // Nom du garage
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nom du garage",
                    prefixIcon: Icon(Icons.home_repair_service),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Requis" : null,
                  onSaved: (val) => _tempName = val!,
                ),

                // Manager
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Manager",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Requis" : null,
                  onSaved: (val) => _tempManager = val!,
                ),

                // Ville
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Ville",
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Requis" : null,
                  onSaved: (val) => _tempCity = val!,
                ),

                // Code postal
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Code postal",
                    prefixIcon: Icon(Icons.local_post_office),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Requis" : null,
                  onSaved: (val) => _tempZipcode = val!,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final newGarage = Garage(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          name: _tempName,
                          city: _tempCity,
                          zipcode: _tempZipcode,
                          manager: _tempManager,
                        );

                        await Provider.of<GarageProvider>(context,
                            listen: false)
                            .addGarage(newGarage);

                        Navigator.pop(context);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final garageProvider = Provider.of<GarageProvider>(context);

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
                onPressed: _showAddGarageModal,
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: GarageList(
            garages: garageProvider.garages,
            onDeleteFromParent: (id) => garageProvider.deleteGarage(id),
          ),
        ),
      ],
    );
  }
}
