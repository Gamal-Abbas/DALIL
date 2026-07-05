import 'baseModel.dart';

class AttractionModel extends BaseModel {
  final String eraId;
  final String location;
  final List relatedKings;
  final double? price;

  AttractionModel({
    required super.id,
    required super.name,
    required super.image,
    required super.description,
    required super.collectionType,
    required this.eraId,
    required this.location,
    required this.relatedKings,
    this.price,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      collectionType: json['collectionType'] ?? 'attractions',
      eraId: json['eraId'] ?? '',
      location: json['location'] ?? '',
      relatedKings: json['relatedKings'] ?? [],
      price: json['price'] != null ? (json['price']).toDouble() : null, // 🆕
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'eraId': eraId,
      'location': location,
      'relatedKings': relatedKings,
      'price': price,
    };
  }
}