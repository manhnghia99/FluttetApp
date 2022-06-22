import 'package:flutter/material.dart';
import 'package:food_panda/authentication/login.dart';
import 'package:food_panda/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //Tạo 2 Tab controller Login và Register cho AuthScreen
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // xóa nút back menu appBar
          flexibleSpace: Container(
            // Cân chỉnh màu cho 2 tab appBar Controller
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          title: const Text('iFood',
              style: TextStyle(
                  fontSize: 60, color: Colors.white, fontFamily: 'Lobster')),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lock, color: Colors.white), text: 'Login'),
              Tab(
                  icon: Icon(Icons.lock, color: Colors.white),
                  text: 'Register'),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          //Tạo màu nền body hiển thị cho 2 tab Controller
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.lightGreen, Colors.amber],
          )),

          // Dùng Widget TabView truyền vào 2 lớp LoginScreen và RegisterScreen cho hiển thị tại body
          child: TabBarView(children: [LoginScreen(), RegisterScreen()]),
        ),
      ),
    );
  }
}
