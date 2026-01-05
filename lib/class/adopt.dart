import 'dart:convert';

class Adopt {
  String? adoptId;
  String? ownerId;
  String? petId;
  String? userId;
  String? adoptName;
  String? adoptMsg;
  String? adoptStatus;
  String? ownerName;
  String? petName;
  String? petType;
  String? petGender;
  String? petAge;
  String? petHealth;
  String? category;
  List<String> imagePaths = [];

  Adopt({
    this.adoptId,
    this.petId,
    this.ownerId,
    this.userId,
    this.adoptName,
    this.adoptMsg,
    this.adoptStatus,
    this.ownerName,

    this.petName,
    this.petType,
    this.petGender,
    this.petAge,
    this.petHealth,
    this.category,
    required this.imagePaths,
  });

  Adopt.fromJson(Map<String, dynamic> json) {
    adoptId = json['adopt_id'];
    petId = json['pet_id'];
    ownerId = json['owner_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    adoptName = json['adopt_name'];
    adoptMsg = json['adopt_msg'];
    adoptStatus = json['adopt_status'];
    ownerName = json['owner_name'];

    petName = json['pet_name'];
    petType = json['pet_type'];
    petGender = json['pet_gender'];
    petAge = json['pet_age'];
    petHealth = json['pet_health'];
    category = json['category'];
    imagePaths = (json['image_paths'] != null && json['image_paths'] != '')
        ? List<String>.from(jsonDecode(json['image_paths']))
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adopt_id'] = adoptId;
    data['pet_id'] = petId;
    data['owner_id'] = ownerId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['adopt_name'] = adoptName;
    data['adopt_msg'] = adoptMsg;
    data['adopt_status'] = adoptStatus;
    data['owner_name'] = ownerName;

    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['pet_gender'] = petGender;
    data['pet_age'] = petAge;
    data['pet_health'] = petHealth;
    data['category'] = category;
    data['image_paths'] = imagePaths;
    return data;
  }
}
