import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// Un FloatingActionButton (FAB) personnalisé et réutilisable
class FloatingButtons extends StatelessWidget {
  // Callback pour exécuter une action définie dans le widget parent (GestionRecetteHome)
  final VoidCallback onPressed;

  const FloatingButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(

      // L'action déclenchée au clic (ici, l'ouverture du BottomSheet)
      onPressed: onPressed,
      // Texte d'accessibilité affiché lors d'un appui long
      tooltip: 'Add new sale',
      // Icône centrale du bouton
      child: const Icon(Ionicons.add_circle_sharp),

    );
  }
}