import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:test1_appgardienbut_fabrice/views/shared/styles/app.style.dart';

import '../../controllers/garage.provider.dart';
import '../../models/game.dart';
import '../shared/colors/colors.app.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  // Affiche la modale de saisie des scores
  void _showInputStatsModal(BuildContext context, Game game, String homeGk, String visitorGk) {
    final provider = Provider.of<GarageProvider>(context, listen: false);
    int hShots = 0, hGoals = 0, vShots = 0, vGoals = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Résultats du Match", style: appStyle(20, AppColors.textColor, FontWeight.bold)),
              const SizedBox(height: 20),

              // Saisie Gardien Domicile
              _stepperSection("🏠 Home GK: $homeGk", hShots, hGoals,
                      (val) => setModalState(() => hShots = val),
                      (val) => setModalState(() => hGoals = val)),

              const Divider(height: 40),

              // Saisie Gardien Visiteur
              _stepperSection("🚩 Visiteur GK: $visitorGk", vShots, vGoals,
                      (val) => setModalState(() => vShots = val),
                      (val) => setModalState(() => vGoals = val)),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    // Enregistre et ferme
                    // provider.updateMatchResults(
                    //   gameId: game.id,
                    //   homeShots: hShots, homeGoals: hGoals,
                    //   visitorShots: vShots, visitorGoals: vGoals,
                    // );
                    // Navigator.pop(context);
                  },
                  child: const Text("VALIDER LES STATS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section regroupant Lancers et Buts
  Widget _stepperSection(String title, int shots, int goals, Function(int) onShots, Function(int) onGoals) {
    return Column(
      children: [
        Text(title, style: appStyle(15, AppColors.primary, FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _counterField("Lancers", shots, onShots),
            _counterField("Buts", goals, onGoals),
          ],
        ),
      ],
    );
  }

  // Boutons + / - personnalisés
  Widget _counterField(String label, int value, Function(int) onChange) {
    return Column(
      children: [
        Text(label, style: appStyle(12, AppColors.secondary, FontWeight.w500)),
        Row(
          children: [
            IconButton(onPressed: () => value > 0 ? onChange(value - 1) : null, icon: const Icon(Icons.remove_circle, color: Colors.redAccent)),
            Text("$value", style: appStyle(20, AppColors.textColor, FontWeight.bold)),
            IconButton(onPressed: () => onChange(value + 1), icon: const Icon(Icons.add_circle, color: Colors.green)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GarageProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // En-tête de la page
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Ionicons.cart_sharp,size: 30),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'Mes Ventes',
                          style: appStyle(30, AppColors.textColor, FontWeight.bold)
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 1),
                        height: 5,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Liste des matchs
           // Expanded(
           //    child: provider.games.isEmpty
           //        ? Center(child: Text("Aucunes ventes pour le moment", style: appStyle(18, AppColors.secondary, FontWeight.w400)))
           //        : ListView.builder(
           //      itemCount: provider.games.length,
           //      itemBuilder: (context, index) {
           //        final game = provider.games[index];
           //        final homeTeam = provider.teams.firstWhere((t) => t.id == game.homeTeamId);
           //        final visitorTeam = provider.teams.firstWhere((t) => t.id == game.visitorTeamId);
           //        final homeGk = provider.goalkeepers.firstWhere((g) => g.id == game.homeGkStats.goalkeeperId);
           //        final visitorGk = provider.goalkeepers.firstWhere((g) => g.id == game.visitorGkStats.goalkeeperId);
           //
           //        return Card(
           //          color: AppColors.backgroundLight,
           //          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
           //          child: ExpansionTile(
           //            leading: _buildVsLogos(homeTeam.urlLogo, visitorTeam.urlLogo),
           //            iconColor: AppColors.primary,
           //            collapsedIconColor: AppColors.secondary,
           //            title: Text("${homeTeam.name} vs ${visitorTeam.name}", style: appStyle(15, AppColors.primary, FontWeight.bold)),
           //            subtitle: Text(
           //              "${game.date.day}/${game.date.month} à ${game.date.hour}h${game.date.minute.toString().padLeft(2, '0')}",
           //              style: appStyle(13, AppColors.secondary, FontWeight.w500),
           //            ),
           //            children: [
           //              // Affiche bouton ou résumé selon statut match
           //              if (!game.isFinished)
           //                Padding(
           //                  padding: const EdgeInsets.all(16.0),
           //                  child: ElevatedButton.icon(
           //                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
           //                    onPressed: () => _showInputStatsModal(context, game, homeGk.name, visitorGk.name),
           //                    icon: const Icon(Icons.edit, color: Colors.white),
           //                    label: const Text("Saisir les résultats", style: TextStyle(color: Colors.white)),
           //                  ),
           //                )
           //              else
           //                _buildStatsSummary(game, homeGk.name, visitorGk.name),
           //            ],
           //          ),
           //        );
           //      },
           //    ),
           //  ),
          ],
        );
      },
    );
  }

  // Logos superposés (Stack)
  Widget _buildVsLogos(String urlHome, String urlVisitor) {
    return SizedBox(
      width: 60,
      child: Stack(
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(urlHome), backgroundColor: Colors.white),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(radius: 18, backgroundImage: NetworkImage(urlVisitor), backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  // Résumé final des arrêts
  Widget _buildStatsSummary(Game game, String homeGkName, String visitorGkName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _gkStatRow(homeGkName, game.homeGkStats.shotsAgainst, game.homeGkStats.goalsAgainst, game.homeGkStats.savePercentage),
          const Divider(),
          _gkStatRow(visitorGkName, game.visitorGkStats.shotsAgainst, game.visitorGkStats.goalsAgainst, game.visitorGkStats.savePercentage),
        ],
      ),
    );
  }

  // Ligne de stat individuelle
  Widget _gkStatRow(String name, int shots, int goals, double pct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(name, style: appStyle(14, AppColors.textColor, FontWeight.bold))),
        Text("$shots Shots / $goals Buts", style: appStyle(13, AppColors.secondary, FontWeight.w500)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
          child: Text("$pct%", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
