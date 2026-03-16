import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/garage.page.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/gardien.page.dart';
import 'package:test1_appgardienbut_fabrice/views/ui/stat.page.dart';
import '../../controllers/teams.provider.dart';
import '../../models/game.dart';
import '../../models/goalkeeper.game.stat.dart';
import '../shared/colors/colors.app.dart';
import '../shared/styles/app.style.dart';
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
    GardienPage(),
    ProfilePage(),
  ];

  // Modale pour programmer un match
  void _showScheduleGameModal(BuildContext context) {
    final provider = Provider.of<TeamsProvider>(context, listen: false);
    final _gameFormKey = GlobalKey<FormState>();

    String? hTeamId, vTeamId;
    String _location = "Stade Municipal";
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

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
            decoration: const BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _gameFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Programmer un Match",
                    style: appStyle(20, AppColors.textColor, FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Champ Lieu
                  TextFormField(
                    initialValue: _location,
                    decoration: const InputDecoration(
                      labelText: "Lieu",
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Requis" : null,
                    onSaved: (val) => _location = val!,
                  ),

                  // Sélecteurs Date et Heure
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          ),
                          leading: const Icon(Icons.calendar_today),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setModalState(() => selectedDate = picked);
                          },
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(selectedTime.format(context)),
                          leading: const Icon(Icons.access_time),
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (picked != null)
                              setModalState(() => selectedTime = picked);
                          },
                        ),
                      ),
                    ],
                  ),

                  // Équipe Domicile
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Équipe Domicile",
                    ),
                    items: provider.teams
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setModalState(() => hTeamId = v),
                    validator: (v) => v == null ? "Requis" : null,
                  ),

                  // Équipe Visiteur (exclut l'équipe domicile)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Équipe Visiteur",
                    ),
                    items: provider.teams
                        .where((t) => t.id != hTeamId)
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setModalState(() => vTeamId = v),
                    validator: (v) => v == null ? "Requis" : null,
                  ),

                  const SizedBox(height: 20),

                  // Bouton de validation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        if (_gameFormKey.currentState!.validate()) {
                          _gameFormKey.currentState!.save();

                          // Fusion Date + Heure
                          final fullDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          final hGk = provider.getGoalkeeperByTeam(hTeamId!);
                          final vGk = provider.getGoalkeeperByTeam(vTeamId!);

                          // Vérifie si les gardiens existent avant création
                          if (hGk != null && vGk != null) {
                            provider.scheduleGame(
                              Game(
                                id: DateTime.now().toString(),
                                date: fullDateTime,
                                homeTeamId: hTeamId!,
                                visitorTeamId: vTeamId!,
                                whereIsGame: _location,
                                homeGkStats: GoalkeeperGameStats(
                                  goalkeeperId: hGk.id,
                                ),
                                visitorGkStats: GoalkeeperGameStats(
                                  goalkeeperId: vGk.id,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Gardiens manquants !"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Créer le match",
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
            onPressed: () => _showScheduleGameModal(context),
          ),
        );
      },
    );
  }
}
