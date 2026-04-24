import 'baseModel.dart';

class KingModel extends BaseModel {
  final String eraId;
  final List relatedAttractions;

  KingModel({
    required super.id,
    required super.name,
    required super.image,
    required super.description,
    required super.collectionType,
    required this.eraId,
    required this.relatedAttractions,
  });

  factory KingModel.fromJson(Map<String, dynamic> json) {
    return KingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      collectionType: json['collectionType'] ?? 'kings',
      eraId: json['eraId'] ?? '',
      relatedAttractions: json['relatedAttractions'] ?? [],
    );
  }
}