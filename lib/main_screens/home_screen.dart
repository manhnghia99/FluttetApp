import 'package:flutter/material.dart';
import 'package:food_panda/authentication/auth_screen.dart';
import 'package:food_panda/global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(sharedPreferences!.getString('name')!),
        centerTitle: true,
        //automaticallyImplyLeading: true,
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
        onPressed: () {
          firebaseAuth.signOut().then((value) {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => AuthScreen()));
          });
        },
      )),
    );
  }
}
