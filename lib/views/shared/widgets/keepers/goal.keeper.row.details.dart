import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/garage.provider.dart';
import '../../../../models/goalkeeper.dart';
import '../../../../models/teams.dart';
import '../../colors/colors.app.dart';
import '../../styles/app.style.dart';

class GoalkeeperRowDetails extends StatelessWidget {
  final Goalkeeper goalkeeper;
  final Teams? team; // Pour afficher le logo et nom de l'équipe associée

  const GoalkeeperRowDetails({super.key, required this.goalkeeper, this.team});
  void _showStatsModal(BuildContext context) {

    // Récupération des stats via le provider
    final provider = Provider.of<GarageProvider>(context, listen: false);
    //final stats = provider.getGoalkeeperTotalStats(goalkeeper.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête : Nom et Drapeau
            Text(goalkeeper.name, style: appStyle(22, AppColors.primary, FontWeight.bold)),
            Text("${goalkeeper.nationality} | ${goalkeeper.height}m", style: appStyle(14, AppColors.secondary, FontWeight.w500)),
            const Divider(height: 30),

            // Ligne des stats numériques
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // _statItem("Matchs", "${stats['matches']}"),
                // _statItem("Tirs Totaux", "${stats['shots']}"),
                // _statItem("Buts encaissés", "${stats['goals']}"),
              ],
            ),
            const SizedBox(height: 25),

            // Badge du pourcentage d'arrêts global
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  //Text("${stats['pct']}%", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Efficacité Totale", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour un bloc de stat
  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () => _showStatsModal(context), // Clic sur la ligne
        child: Card(
        color: AppColors.backgroundLight,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              goalkeeper.name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            goalkeeper.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Taille: ${goalkeeper.height}m | ${goalkeeper.nationality}",
          ),
          trailing: team != null
              ? SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // TRÈS IMPORTANT
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        team!.urlLogo,
                        width: 25,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      Text(
                        team!.name,
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ), // Si le nom est trop long),
                    ],
                  ),
                )
              : const Icon(Icons.help_outline),
        ),
            ),
      );
  }
}
