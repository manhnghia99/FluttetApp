import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_panda/authentication/auth_screen.dart';
import 'package:food_panda/global/global.dart';
import 'package:food_panda/main_screens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  //tạo hàm startTimer để hiện hình ảnh và tên app ứng dụng đang load trong 3 second
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      // if seller is logging already
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      } else
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => AuthScreen()));
    });
  }

// cho hàm startTimer vào void initState những trạng thái của màn hình hiển thị trên thiết bị
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Tạo 1 widget container màu nền trắng cho thêm ảnh, tên app lúc begin start
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('./images/splash.jpg'),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(18.0),
            ),
            const Text(
              'Sell Food Online',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.amber,
                fontSize: 40,
                fontFamily: 'FontsFree',
                letterSpacing: 3,
                wordSpacing: 20, //Khoảng cách chữ
                //decorationStyle: TextDecorationStyle.wavy, //kiêu gạch line dưới chữ
                decoration: TextDecoration.none, //bỏ line gạch dưới chữ
              ),
            ),
          ],
        ),
      ),
    );
  }
}
