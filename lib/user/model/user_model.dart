class UserModel {
  final String uid;
  final String? userID;
  final String? userName;
  final int passTicket;
  final int point;
  final String? phoneNumber;
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
