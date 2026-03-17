import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sale.model.dart';
import '../services/sale.service.dart';

class SaleProvider extends ChangeNotifier {
  final SaleService _saleService = SaleService();

  final Map<String, List<Sale>> _salesByGarageId = {};
  final Map<String, bool> _loadingByGarageId = {};

  List<Sale> salesForGarage(String garageId) => _salesByGarageId[garageId] ?? [];
  bool isLoadingForGarage(String garageId) => _loadingByGarageId[garageId] ?? false;

  List<Sale> _favoriteSales = [];
  List<Sale> get favoriteSales => _favoriteSales;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSales(String garageId) async {
    _loadingByGarageId[garageId] = true;
    notifyListeners();

    try {
      _salesByGarageId[garageId] = await _saleService.getSales(garageId);
    } finally {
      _loadingByGarageId[garageId] = false;
      notifyListeners();
    }
  }

  Future<String?> loadFavoriteSalesForGarages(List<String> garageIds) async {
    try {
      final fetchedLists = await Future.wait(
        garageIds.map((id) => _saleService.getFavoriteSalesForGarage(id)),
      );
      final fetched = fetchedLists.expand((x) => x).toList();
      final seen = <String>{};
      _favoriteSales = [
        for (final s in fetched)
          if (seen.add('${s.garageId}__${s.id}')) s
      ];
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      return "Impossible de charger les favoris (${e.code}).";
    } catch (e) {
      return "Impossible de charger les favoris.";
    }
  }

  Future<String?> addSale(String garageId, Sale sale) async {
    try {
      await _saleService.addSale(garageId, sale);
      final list = _salesByGarageId[garageId] ?? [];
      _salesByGarageId[garageId] = [...list, sale];
      notifyListeners();
      return null;
    } catch (e) {
      return "Erreur lors de l'enregistrement de la vente.";
    }
  }

  Future<String?> deleteSale(String garageId, String saleId) async {
    final current = _salesByGarageId[garageId] ?? [];
    final next = current.where((s) => s.id != saleId).toList();
    _salesByGarageId[garageId] = next;
    notifyListeners();
    try {
      await _saleService.deleteSale(garageId, saleId);
      return null;
    } catch (e) {
      // revert
      _salesByGarageId[garageId] = current;
      notifyListeners();
      return "Erreur lors de la suppression.";
    }
  }

  Future<String?> toggleFavorite(String garageId, Sale sale) async {
    final previous = sale.isFavorite;
    sale.isFavorite = !previous;
    notifyListeners();
    try {
      await _saleService.toggleFavorite(garageId, sale);
      final key = '${sale.garageId}__${sale.id}';
      if (sale.isFavorite) {
        final exists = _favoriteSales.any((s) => '${s.garageId}__${s.id}' == key);
        if (!exists) _favoriteSales = [..._favoriteSales, sale];
      } else {
        _favoriteSales =
            _favoriteSales.where((s) => '${s.garageId}__${s.id}' != key).toList();
      }
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      sale.isFavorite = previous;
      notifyListeners();
      return "Impossible de mettre à jour le favori (${e.code}).";
    } catch (e) {
      sale.isFavorite = previous;
      notifyListeners();
      return "Impossible de mettre à jour le favori (vérifiez internet).";
    }
  }

}
