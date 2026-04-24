import 'baseModel.dart';

class AttractionModel extends BaseModel {
  final String eraId;
  final String location;
  final List relatedKings;

  AttractionModel({
    required super.id,
    required super.name,
    required super.image,
    required super.description,
    required super.collectionType,
    required this.eraId,
    required this.location,
    required this.relatedKings,
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
    );
  }
}