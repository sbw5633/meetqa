import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 4)
class UserModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String? userID;
  @HiveField(2)
  final String? userName;
  @HiveField(3)
  final int passTicket;
  @HiveField(4)
  final int point;
  @HiveField(5)
  final String? phoneNumber;
  @HiveField(6)
  final String? photoURL;

  UserModel({
    required this.uid,
    required this.userID,
    this.userName,
    required this.passTicket,
    required this.point,
    this.phoneNumber,
    this.photoURL,
  });

  factory UserModel.fromDB(Map<String, dynamic> data) {
    return UserModel(
      uid: data["uid"],
      userID: data["userID"],
      userName: data["userName"],
      passTicket: data["passTicket"],
      point: data["point"],
      phoneNumber: data["phoneNumber"],
      photoURL: data["photoURL"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "userID": userID,
      "userName": userName,
      "passTicket": passTicket,
      "point": point,
      "phoneNumber": phoneNumber,
      "photoURL": photoURL,
    };
  }
}
