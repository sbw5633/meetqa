enum Gender {
  Male,
  Female,
  Unselect,
}

class PersonModel {
  final String name;
  final Gender gender;

  PersonModel({required this.name, required this.gender});

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json["name"],
      gender: json["gender"],
    );
  }
}
