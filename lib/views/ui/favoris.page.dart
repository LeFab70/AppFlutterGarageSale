import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/garage.provider.dart';

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
    final _formKey = GlobalKey<FormState>();




    final GarageProvider provider = Provider.of<GarageProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favories',
                style: appStyle(30, Colors.black, FontWeight.bold),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.add_circle, size: 40),
              ),
            ],
          ),
        ),
        // Expanded(
        //   // child: GoalkeeperList(
        //   //   //gkList: provider.goalkeepers,
        //   //   //onDelete: (gkId) => provider.deleteGoalkeeper(gkId),
        //   // ),
        // ),
      ],
    );
  }
}
