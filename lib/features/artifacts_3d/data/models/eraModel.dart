import 'baseModel.dart';

class EraModel extends BaseModel {
  final int? startYear;
  final int? endYear;

  EraModel({
    required super.id,
    required super.name,
    required super.image,
    required super.description,
    required super.collectionType,
    required this.startYear,
    required this.endYear,
  });

  factory EraModel.fromJson(Map<String, dynamic> json) {
    return EraModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      collectionType: json['collectionType'] ?? 'eras',
      // استخدم toInt() لضمان تحويل القيمة السالبة من Firestore بشكل صحيح
      startYear: json['startYear'] != null
          ? (json['startYear'] as num).toInt()
          : null,
      endYear: json['endYear'] != null
          ? (json['endYear'] as num).toInt()
          : null,
    );
  }
}
