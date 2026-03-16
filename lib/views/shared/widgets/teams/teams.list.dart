import 'package:flutter/material.dart';
import 'teams.row.details.dart';
import '../../../../models/teams.dart';

class TeamsList extends StatelessWidget {
  final List<Teams> teamsList;
  final Function(int) onDeleteFromParent;

  const TeamsList({
    super.key,
    required this.teamsList,
    required this.onDeleteFromParent,
  });

  @override
  Widget build(BuildContext context) {
    return teamsList.isEmpty
        ? Center(
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              "Liste de garages vide",
              style: const TextStyle(fontSize: 24),
            ),
          )
        : ListView.builder(
            itemCount: teamsList.length,
            itemBuilder: (context, index) {
              final team = teamsList[index];
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutQuad,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Dismissible(
                  key: ValueKey(team.id),
                  // Utilise l'id unique
                  direction: DismissDirection.endToStart,
                  // 1. On confirme d'abord action supprission
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Confirmation"),
                        content: Text("Supprimer '${team.name}' ?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text("ANNULER"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text(
                              "OUI",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  // 2. Si confirmé, on exécute l'action
                  onDismissed: (direction) {
                    onDeleteFromParent(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${team.name} supprimé"),
                        backgroundColor: Colors.black87,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: TeamsRowDetails(team: team),
                ),
              );
            },
          );
  }
}
