import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/garage.provider.dart';
import '../../models/goalkeeper.dart';
import '../shared/colors/colors.app.dart';
import '../shared/styles/app.style.dart';
import '../shared/widgets/keepers/goal.keeper.list.dart';

class GardienPage extends StatefulWidget {
  const GardienPage({super.key});

  @override
  State<GardienPage> createState() => _GardienPageState();
}

class _GardienPageState extends State<GardienPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    //variable pour gardien
    String _name = '', _nat = '', _teamId = '';
    double _height = 0.0;

    //funtion ajout gardien

    void _showAddGKModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
          builder: (context, setModalState) {
            final provider = Provider.of<GarageProvider>(context);
           // final availableTeams = provider.teamsWithoutGoalkeeper;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ajouter un Gardien",
                        style: appStyle(20, Colors.black, FontWeight.bold),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Nom"),
                        onSaved: (v) => _name = v!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nationalité",
                        ),
                        onSaved: (v) => _nat = v!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Taille (ex: 1.90)",
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (v) => _height = double.parse(v!),
                      ),
                      const SizedBox(height: 10),
                      // DropdownButtonFormField<String>(
                      //   hint: const Text("Choisir une équipe libre"),
                      //   // items: availableTeams
                      //   //     .map(
                      //   //       (t) => DropdownMenuItem(
                      //   //         value: t.id,
                      //   //         child: Text(t.name),
                      //   //       ),
                      //   //     )
                      //   //     .toList(),
                      //   onChanged: (v) => _teamId = v!,
                      //   validator: (v) => v == null ? "Obligatoire" : null,
                      // ),
                       SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            //   _formKey.currentState!.save();
                            //   provider.addGoalkeeper(
                            //     Goalkeeper(
                            //       id: DateTime.now().toString(),
                            //       name: _name,
                            //       nationality: _nat,
                            //       teamId: _teamId,
                            //       height: _height,
                            //     ),
                            //   );
                            //   Navigator.pop(context);
                            // }
                          },
                          child: const Text(
                            "Assigner équipe",
                            style: TextStyle(color: Colors.white,fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    final GarageProvider provider = Provider.of<GarageProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gardiens',
                style: appStyle(30, Colors.black, FontWeight.bold),
              ),
              IconButton(
                onPressed: _showAddGKModal,
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
