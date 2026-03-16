import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/garage.provider.dart';
import '../../../../models/goalkeeper.dart';
import 'goal.keeper.row.details.dart';

class GoalkeeperList extends StatelessWidget {
  final List<Goalkeeper> gkList;
  final Function(String) onDelete;

  const GoalkeeperList({
    super.key,
    required this.gkList,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GarageProvider>(context);

    return gkList.isEmpty
        ? const Center(child: Text("Aucun gardien enregistré"))
        : ListView.builder(
            itemCount: gkList.length,
            itemBuilder: (context, index) {
              final gk = gkList[index];
              // On cherche l'équipe pour afficher le logo
              //final team = provider.teams.firstWhere((t) => t.id == gk.teamId);

              return Dismissible(
                key: ValueKey(gk.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => onDelete(gk.id),
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Text("data"),
                //child: GoalkeeperRowDetails(goalkeeper: gk, team: team),
              );
            },
          );
  }
}
