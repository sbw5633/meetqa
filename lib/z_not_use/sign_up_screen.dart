// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'package:meetqa/component/unit/custom_text_field.dart';
// import 'package:meetqa/const/user_id.dart';
// import 'package:meetqa/model/user_model.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final GlobalKey<FormState> formKey = GlobalKey();

//   String? name;

//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       scrollable: true,
//       title: const Text(
//         "환영합니다!",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             color: Colors.black, fontWeight: FontWeight.w700, fontSize: 35),
//       ),
//       content: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomTextField(
//                 label: "이름(닉네임)",
//                 onSaved: (String? val) => name = val!,
//                 validatorMsg: "이름을 입력해주세요",
//                 maxLength: 8,
//                 textInputType: TextInputType.name),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//             onPressed: isLoading ? null : () => onSavePressed(context),
//             child: isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Text("확인")),
//         TextButton(
//             onPressed: isLoading ? null : () => Navigator.pop(context),
//             child: Text("취소")),
//       ],
//     );
//   }

//   Future<void> onSavePressed(BuildContext context) async {
//     if (formKey.currentState == null) {
//       return;
//     }
//     if (formKey.currentState!.validate()) {
//       print("currentUser!@: $currentUser");

//       formKey.currentState!.save();
//       final _newUser = UserModel(
//         uid: currentUser!.uid,
//         userID: currentUser!.email,
//         userName: name!,
//         passTicket: 3,
//         point: 0,
//         displayName: currentUser!.displayName,
//         phoneNumber: currentUser!.phoneNumber,
//         photoURL: currentUser!.photoURL,
//       );

//       setState(() {
//         isLoading = true;
//       });

//       await FirebaseFirestore.instance
//           .collection("User")
//           .doc(_newUser.uid)
//           .set(_newUser.toMap());

//       setState(() {
//         isLoading = false;
//       });

//       nowUser = _newUser;

//       userName = nowUser!.userID;

//       Navigator.of(context).pop(true);
//     }
//   }
// }
