import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'garage.page.dart';
import 'favoris.page.dart';
import 'stat.page.dart';
import '../../controllers/garage.provider.dart';
import '../../controllers/sale.provider.dart';
import '../../models/sale.model.dart';
import '../shared/colors/colors.app.dart';
import '../shared/data/sale_categories.dart';

import '../shared/widgets/app.bar.dart';
import '../shared/widgets/floating.buttons.dart';

import '../../controllers/main.screen.provider.dart';
import '../shared/widgets/safe.area.widget.dart';
import 'profile.page.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  // Pages de la navigation
  final List<Widget> pageList = [
    StatPage(),
    GaragePage(),
    FavoriPage(),
    ProfilePage(),
  ];

  // Modale pour enregistrer un vente
  void _showSelectGarageForSale(BuildContext context) {
    final garageProvider = Provider.of<GarageProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Sélectionner un garage",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              ...garageProvider.garages.map((g) {
                return ListTile(
                  leading: const Icon(Icons.home_repair_service),
                  title: Text(g.name),
                  subtitle: Text("${g.city} (${g.zipcode})"),
                  onTap: () {
                    Navigator.pop(context); // fermer la liste
                    _showAddSaleModal(context, g.id); // ouvrir le formulaire de vente
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
  void _showAddSaleModal(BuildContext context, String garageId) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final _formKey = GlobalKey<FormState>();

    //premier element dans la list
    String category = SaleCategories.categories.first;
    String noteItem = "";
    String imageUrl = "";
    DateTime date = DateTime.now();
    TimeOfDay start = TimeOfDay.now();
    TimeOfDay end = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Nouvelle vente",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Catégorie (Dropdown)
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: "Catégorie",
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: SaleCategories.categories
                        .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ))
                        .toList(),
                    onChanged: (v) => setModalState(() => category = v!),
                  ),

                  // Description
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                    ),
                    onSaved: (v) => noteItem = v ?? "",
                  ),

                  // Image URL
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "URL de l'image",
                      prefixIcon: Icon(Icons.image),
                      hintText: "https://exemple.com/photo.jpg",
                    ),
                    onSaved: (v) => imageUrl = v ?? "",
                  ),

                  const SizedBox(height: 15),

                  // Sélecteur de date
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setModalState(() => date = picked);
                      }
                    },
                  ),

                  // Sélecteurs d'heures
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text("Début : ${start.format(context)}"),
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: start,
                            );
                            if (picked != null) {
                              setModalState(() => start = picked);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: const Icon(Icons.access_time_filled),
                          title: Text("Fin : ${end.format(context)}"),
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: end,
                            );
                            if (picked != null) {
                              setModalState(() => end = picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Bouton d'enregistrement
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final sale = Sale(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            dateVente: date,
                            startTime: start.format(context),
                            endTime: end.format(context),
                            category: category,
                            noteItem: noteItem,
                            imageUrl: imageUrl,
                            garageId: garageId
                          );

                          await saleProvider.addSale(garageId, sale);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Enregistrer",
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
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          appBar: AppBars(onPressed: () {}),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // Corps changeant selon l'index du Provider
          body: pageList[mainScreenNotifier.pageIndex],
          // Barre de navigation personnalisée
          bottomNavigationBar: BottomAppBar(
            notchMargin: 6.0,
            shape: const CircularNotchedRectangle(),
            clipBehavior: Clip.antiAlias,
            child: SafeAreaWidget(
              currentIndex: mainScreenNotifier.pageIndex,
              changedIndex: (index) => mainScreenNotifier.pageIndex = index,
            ),
          ),
          // Bouton central pour ajouter un match
          floatingActionButton: FloatingButtons(
            onPressed: () => _showSelectGarageForSale(context),
          ),
        );
      },
    );
  }
}
