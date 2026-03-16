import 'package:flutter/material.dart';
import 'garage.row.details.dart';
import '../../../../models/garage.dart';

class GarageList extends StatelessWidget {
  final List<Garage> garages;
  final Function(String) onDeleteFromParent;

  const GarageList({
    super.key,
    required this.garages,
    required this.onDeleteFromParent,
  });

  @override
  Widget build(BuildContext context) {
    return garages.isEmpty
        ? const Center(
      child: Text(
        "Liste de garages vide",
        style: TextStyle(fontSize: 24),
      ),
    )
        : ListView.builder(
      itemCount: garages.length,
      itemBuilder: (context, index) {
        final garage = garages[index];

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
            key: ValueKey(garage.id),
            direction: DismissDirection.endToStart,

            // Confirmation avant suppression
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirmation"),
                  content: Text("Supprimer '${garage.name}' ?"),
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

            // Suppression confirmée
            onDismissed: (direction) {
              onDeleteFromParent(garage.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${garage.name} supprimé"),
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

            child: GarageRowDetails(garage: garage),
          ),
        );
      },
    );
  }
}
