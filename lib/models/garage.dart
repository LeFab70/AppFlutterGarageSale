class Garage {
  final String id;
  final String name;
  final String city;
  final String zipcode;
  final String manager;

  Garage({
    required this.id,
    required this.name,
    required this.city,
    required this.zipcode,
    required this.manager,
  });

  //Convertion des données pour stokage firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'zipcode': zipcode,
      'manager': manager,
    };
  }

  //convertion des données recues de firestore
  factory Garage.fromMap(String id, Map<String, dynamic> map) {
    return Garage(
      id: id,
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      zipcode: map['zipcode'] ?? '',
      manager: map['manager'] ?? '',
    );
  }
}
// toMap()	Convertit un objet Dart → Map pour Firestore
// fromMap()	Convertit une Map Firestore → objet Dart
// factory	Permet une création contrôlée et flexible de l’objet