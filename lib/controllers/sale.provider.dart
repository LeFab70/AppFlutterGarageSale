import 'package:flutter/material.dart';
import '../models/sale.model.dart';
import '../services/sale.service.dart';

class SaleProvider extends ChangeNotifier {
  final SaleService _saleService = SaleService();

  List<Sale> _sales = [];
  List<Sale> get sales => _sales;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSales(String garageId) async {
    _isLoading = true;
    notifyListeners();

    _sales = await _saleService.getSales(garageId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSale(String garageId, Sale sale) async {
    await _saleService.addSale(garageId, sale);
    _sales.add(sale);
    notifyListeners();
  }

  Future<void> deleteSale(String garageId, String saleId) async {
    await _saleService.deleteSale(garageId, saleId);
    _sales.removeWhere((s) => s.id == saleId);
    notifyListeners();
  }

  Future<void> toggleFavorite(String garageId, Sale sale) async {
    sale.isFavorite = !sale.isFavorite;
    notifyListeners();
    await _saleService.toggleFavorite(garageId, sale);
  }

}
