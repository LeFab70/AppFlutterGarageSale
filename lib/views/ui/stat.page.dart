import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../controllers/garage.provider.dart';
import '../../controllers/sale.provider.dart';
import '../../models/sale.model.dart';
import '../shared/colors/colors.app.dart';
import '../shared/styles/app.style.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    final garageProvider = Provider.of<GarageProvider>(context);
    final saleProvider = Provider.of<SaleProvider>(context);

    return Column(
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Row(
            children: [
              const Icon(Ionicons.cart_sharp, size: 30),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mes Ventes",
                      style: appStyle(30, AppColors.textColor, FontWeight.bold)),
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

        // LISTE DES GARAGES + VENTES
        Expanded(
          child: garageProvider.garages.isEmpty
              ? Center(
            child: Text(
              "Aucun garage enregistré",
              style: appStyle(18, AppColors.secondary, FontWeight.w400),
            ),
          )
              : ListView.builder(
            itemCount: garageProvider.garages.length,
            itemBuilder: (context, index) {
              final garage = garageProvider.garages[index];

              return Card(
                color: AppColors.backgroundLight,
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.secondary,
                  title: Text(
                    garage.name,
                    style: appStyle(
                        16, AppColors.primary, FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${garage.city} (${garage.zipcode})",
                    style: appStyle(
                        13, AppColors.secondary, FontWeight.w500),
                  ),

                  // Quand on ouvre → charger les ventes
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      saleProvider.loadSales(garage.id);
                    }
                  },

                  children: [
                    if (saleProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      )
                    else if (saleProvider.sales.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Aucune vente pour ce garage",
                          style: appStyle(
                              14, AppColors.secondary, FontWeight.w400),
                        ),
                      )
                    else
                      ...saleProvider.sales.map(
                            (sale) => _buildSaleRow(sale,garage.id),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // WIDGET D'AFFICHAGE D'UNE VENTE
  Widget _buildSaleRow(Sale sale, String garageId) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                backgroundImage: NetworkImage(sale.imageUrl),
                backgroundColor: Colors.grey[200],
              )
                  : const CircleAvatar(
                child: Icon(Icons.image_not_supported),
              ),
              title: Text(
                sale.category,
                style: appStyle(15, AppColors.primary, FontWeight.bold),
              ),
              subtitle: Text(
                "${sale.startTime} - ${sale.endTime}\n${sale.noteItem}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: appStyle(13, AppColors.secondary, FontWeight.w400),
              ),
              trailing: Text(
                "${sale.dateVente.day}/${sale.dateVente.month}/${sale.dateVente.year}",
                style: appStyle(12, AppColors.textColor, FontWeight.w500),
              ),
            ),

            const SizedBox(height: 8),

            // Ligne d’actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FAVORIS
                IconButton(
                  icon: Icon(
                    sale.isFavorite ? Icons.star : Icons.star_border,
                    color: sale.isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    saleProvider.toggleFavorite(garageId, sale);
                  },
                ),

                // DELETE
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    saleProvider.deleteSale(garageId, sale.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
