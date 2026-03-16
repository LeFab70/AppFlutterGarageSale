class Sale {
  final String id;
  final DateTime dateVente;
  final String startTime;
  final String endTime;
  final String category;
  final String noteItem;

  Sale({
    required this.id,
    required this.dateVente,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.noteItem,
  });

  //Convertion des données pour stokage firestore
  Map<String, dynamic> toMap() {
    return {
      'dateVente': dateVente.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'noteItem': noteItem,
    };
  }

  //convertion des données recues de firestore
  factory Sale.fromMap(String id, Map<String, dynamic> map) {
    return Sale(
      id: id,
      dateVente: DateTime.parse(map['dateVente']),
      startTime: map['startTime'],
      endTime: map['endTime'],
      category: map['category'],
      noteItem: map['noteItem'],
    );
  }
}
// toMap()	Convertit un objet Dart → Map pour Firestore
// fromMap()	Convertit une Map Firestore → objet Dart
// factory	Permet une création contrôlée et flexible de l’objet