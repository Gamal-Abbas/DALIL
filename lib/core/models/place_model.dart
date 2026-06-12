class PlaceModel {
  final String id;
  final Map<String, dynamic> name;
  final Map<String, dynamic> description;
  final String image;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory PlaceModel.fromFirestore(doc) {
    final data = doc.data();

    return PlaceModel(
      id: doc.id,
      name: data['name'] ?? {},
      description: data['description'] ?? {},
      image: data['image'] ?? '',
    );
  }

  String getName(String lang) {
    return name[lang] ?? 'No Title';
  }

  String getDescription(String lang) {
    return description[lang] ?? '';
  }
}