class BaseModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final String collectionType;

  BaseModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.collectionType,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      collectionType: json['collectionType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "description": description,
      "collectionType": collectionType,
    };
  }
}