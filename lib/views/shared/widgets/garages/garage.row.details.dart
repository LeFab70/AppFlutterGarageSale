import 'package:flutter/material.dart';
import 'package:test1_appgardienbut_fabrice/views/shared/colors/colors.app.dart';
import '../../../../models/garage.dart';

class GarageRowDetails extends StatelessWidget {
  final Garage garage;

  const GarageRowDetails({super.key, required this.garage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundLight,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: const Icon(
            Icons.home_repair_service,
            color: AppColors.primary,
          ),
        ),

        title: Text(
          garage.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manager : ${garage.manager}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${garage.city} (${garage.zipcode})",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
