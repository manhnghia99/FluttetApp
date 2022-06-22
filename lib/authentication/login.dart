import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_panda/global/global.dart';
import 'package:food_panda/main_screens/home_screen.dart';
import 'dart:async';
import 'package:food_panda/widget/custom_text_field.dart';
import 'package:food_panda/widget/error_dialog.dart';
import 'package:food_panda/widget/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Tạo key: cho Form trong biến TextEditController có giá trị Null kế thừa thuộc tính trong file custom_text_field.dart
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: 'Please write email/password',
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: 'Checking Credentials',
          );
        });

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      await sharedPreferences!.setString('uid', currentUser.uid);
      await sharedPreferences!
          .setString('email', snapshot.data()!['sellerEmail']);
      await sharedPreferences!
          .setString('name', snapshot.data()!['sellerName']);
      await sharedPreferences!
          .setString('photoUrl', snapshot.data()!['sellerAvatarUrl']);
    });
  }

  @override
  Widget build(BuildContext context) {
    // tạo một Single Child Scroll View để quản lý thông tin đăng ký nếu quá dài có thể cuộn để xem .
    return SingleChildScrollView(
      // tạo 1 widget column và Widget container cho thêm ảnh vào
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset(
                  './images/seller.png',
                  height: 270,
                )),
          ),

          // Tạo Widget Form đăng nhập login app
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'Email',
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObsecre: true,
                ),
              ],
            ),
          ),

          // Tạo nút nhấn đăng nhập cho App
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            child: Text('Sign In',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
          ),
        ],
      ),
    );
  }
}
