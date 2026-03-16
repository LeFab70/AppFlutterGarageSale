import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/garage.dart';


class GarageService {
  final CollectionReference garagesRef =
  FirebaseFirestore.instance.collection('garages');

  Future<void> addGarage(Garage garage) async {
    await garagesRef.doc(garage.id).set(garage.toMap());
  }

  Future<List<Garage>> getGarages() async {
    final snapshot = await garagesRef.get();
    return snapshot.docs
        .map((doc) => Garage.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteGarage(String id) async {
    await garagesRef.doc(id).delete();
  }
}
