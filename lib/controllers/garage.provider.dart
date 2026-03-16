import 'package:flutter/material.dart';
import '../models/garage.dart';
import '../services/garage.service.dart';

class GarageProvider extends ChangeNotifier {
  final GarageService _garageService = GarageService();

  List<Garage> _garages = [];
  List<Garage> get garages => _garages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GarageProvider() {
    loadGarages();
  }

  Future<void> loadGarages() async {
    _isLoading = true;
    notifyListeners();

    _garages = await _garageService.getGarages();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGarage(Garage garage) async {
    await _garageService.addGarage(garage);
    _garages.add(garage);
    notifyListeners();
  }

  Future<void> deleteGarage(String id) async {
    await _garageService.deleteGarage(id);
    _garages.removeWhere((g) => g.id == id);
    notifyListeners();
  }
}
