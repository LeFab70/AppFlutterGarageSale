import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/garage.provider.dart';
import '../../controllers/sale.provider.dart';
import '../../models/sale.model.dart';
import '../shared/colors/colors.app.dart';
import '../shared/styles/app.style.dart';

class FavoriPage extends StatefulWidget {
  const FavoriPage({super.key});

  @override
  State<FavoriPage> createState() => _FavoriPageState();
}

class _FavoriPageState extends State<FavoriPage> {
  @override
  Widget build(BuildContext context) {
    final garageProvider = Provider.of<GarageProvider>(context);
    final saleProvider = Provider.of<SaleProvider>(context);

    // Charger toutes les ventes de tous les garages
    List<Sale> favoriteSales = [];
    Map<String, String> garageNames = {};

    for (var g in garageProvider.garages) {
      garageNames[g.id] = g.name;

      // On charge les ventes du garage
      for (var s in saleProvider.sales) {
        if (s.isFavorite) {
          favoriteSales.add(s);
        }
      }
    }

    return Column(
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Row(
            children: [
              const Icon(Icons.star, size: 30, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Favoris',
                style: appStyle(30, Colors.black, FontWeight.bold),
              ),
            ],
          ),
        ),

        Expanded(
          child: favoriteSales.isEmpty
              ? Center(
            child: Text(
              "Aucune vente en favoris",
              style: appStyle(18, AppColors.secondary, FontWeight.w400),
            ),
          )
              : ListView.builder(
            itemCount: favoriteSales.length,
            itemBuilder: (context, index) {
              final sale = favoriteSales[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                color: AppColors.backgroundLight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ligne principale
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: sale.imageUrl.isNotEmpty
                            ? CircleAvatar(
                          backgroundImage:
                          NetworkImage(sale.imageUrl),
                          backgroundColor: Colors.grey[200],
                        )
                            : const CircleAvatar(
                          child: Icon(Icons.image_not_supported),
                        ),
                        title: Text(
                          sale.category,
                          style: appStyle(16, AppColors.primary,
                              FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${sale.startTime} - ${sale.endTime}\n${sale.noteItem}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(13, AppColors.secondary,
                              FontWeight.w400),
                        ),
                        trailing: Text(
                          "${sale.dateVente.day}/${sale.dateVente.month}/${sale.dateVente.year}",
                          style: appStyle(12, AppColors.textColor,
                              FontWeight.w500),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Nom du garage
                      Text(
                        "Garage : ${garageNames[sale.garageId] ?? "Inconnu"}",
                        style: appStyle(
                            13, AppColors.secondary, FontWeight.w500),
                      ),

                      const SizedBox(height: 8),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Retirer des favoris
                          IconButton(
                            icon: const Icon(Icons.star,
                                color: Colors.amber),
                            onPressed: () {
                              saleProvider.toggleFavorite(
                                  sale.garageId, sale);
                            },
                          ),

                          // // Supprimer la vente
                          // IconButton(
                          //   icon: const Icon(Icons.delete,
                          //       color: Colors.red),
                          //   onPressed: () {
                          //     saleProvider.deleteSale(
                          //         sale.garageId, sale.id);
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
