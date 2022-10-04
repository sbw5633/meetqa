import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/user/model/user_model.dart';

String? userName;

UserModel? nowUser;

User? currentUser;

List<PersonModel> user = [];

String initName1 = '나';
String initName2 = '너';
