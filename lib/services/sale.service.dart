import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/sale.model.dart';


class SaleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addSale(String garageId, Sale sale) async {
    await _db
        .collection('garages')
        .doc(garageId)
        .collection('sales')
        .doc(sale.id)
        .set(sale.toMap());
  }

  Future<List<Sale>> getSales(String garageId) async {
    final snapshot = await _db
        .collection('garages')
        .doc(garageId)
        .collection('sales')
        .get();

    return snapshot.docs
        .map((doc) => Sale.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> deleteSale(String garageId, String saleId) async {
    await _db
        .collection('garages')
        .doc(garageId)
        .collection('sales')
        .doc(saleId)
        .delete();
  }

  Future<void> toggleFavorite(String garageId, Sale sale) async {
    await _db
        .collection('garages')
        .doc(garageId)
        .collection('sales')
        .doc(sale.id)
        .update({'isFavorite': !sale.isFavorite});
  }


}
