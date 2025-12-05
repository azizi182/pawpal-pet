import 'dart:convert';

class petDetails {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  String? latitude;
  String? longitude;
  String? date;
  String? userName;
  List<String> imagePaths = [];

  petDetails({
    required this.petId,
    required this.userId,
    required this.petName,
    required this.petType,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.userName,
    required this.imagePaths,
  });

  petDetails.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    category = json['category'];
    description = json['description'];
    latitude = json['lat'];
    longitude = json['lng'];
    date = json['date'];
    userName = json['user_name'];
    imagePaths = (json['image_paths'] != null && json['image_paths'] != '')
        ? List<String>.from(jsonDecode(json['image_paths']))
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['category'] = category;
    data['description'] = description;
    data['lat'] = latitude;
    data['lng'] = longitude;
    data['date'] = date;
    data['user_name'] = userName;
    data['image_paths'] = imagePaths;
    return data;
  }
}
