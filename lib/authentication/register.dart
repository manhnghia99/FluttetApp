import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_panda/global/global.dart';
import 'package:food_panda/main_screens/home_screen.dart';
import 'package:food_panda/widget/custom_text_field.dart';
import 'package:food_panda/widget/error_dialog.dart';
import 'package:food_panda/widget/loading_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//Tạo key: cho Form trong biến TextEditController có giá trị Null kế thừa thuộc tính trong file custom_text_field.dart
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;

  List<Placemark>? placeMarks;

  String sellerImageUrl = '';
  String _completeAddress = '';

  Future<void> _getGallery() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    //imageXFile = await _picker.pickImage(source: ImageSource.camera); giải quyết sau

//     Future<void> _getCamImage() async {
//    //imageXFile = await _picker.pickImage(source: ImageSource.gallery);
//       imageXFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      imageXFile;
      //_getCamImage();
    });
  }

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true);
    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];
    _completeAddress =
        '${pMark.street} ,  ${pMark.subAdministrativeArea} ,${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = _completeAddress;
  }
  // late Position _currentPosition;
  // late String _currentAddress;
  // _getCurrentLocation() {
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.best,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //       _getAddressFromLatLng();
  //       //locationController.text =( _getCurrentLocation();
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);

  //     Placemark place = placemarks[0];

  //     setState(() {
  //       _currentAddress =
  //           "${place.locality}, ${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> fromValidation() async {
    {
      if (imageXFile == null) {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: 'Please select an image',
              );
            });
      } else {
        if (passwordController.text == confirmPasswordController.text) {
          if (confirmPasswordController.text.isNotEmpty &&
              emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              phoneController.text.isNotEmpty &&
              nameController.text.isNotEmpty) {
            //start uploading image
            showDialog(
                context: context,
                builder: (c) {
                  return LoadingDialog(
                    message: 'Registering Account',
                  );
                });
            // tải lên hình ảnh khi Sign Up
            String fileName = DateTime.now().millisecondsSinceEpoch.toString();
            fStorage.Reference reference = fStorage.FirebaseStorage.instance
                .ref()
                .child('sellers')
                .child(fileName);
            fStorage.UploadTask uploadTask =
                reference.putFile(File(imageXFile!.path));
            fStorage.TaskSnapshot taskSnapshot =
                await uploadTask.whenComplete(() {});
            await taskSnapshot.ref.getDownloadURL().then((url) {
              sellerImageUrl = url;
              //save info firestore
              authenticateSellerAndSignUp();
            });
          } else {
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(
                    message:
                        'Please write the complete require info for Registers',
                  );
                });
          }
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: 'password do no match',
                );
              });
        }
      }
    }
  }

  //kiểm tra việc đăng ký email người dùng.
  void authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message
                  .toString(), //báo lỗi khi email đã được đăng ký rồi.
            );
          });
    });
    // dữ liệu sẽ được lưu vào firestore console
    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  //save data on FireStore
  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection('sellers').doc(currentUser.uid).set({
      'sellerUID': currentUser.uid,
      'sellerEmail': currentUser.email,
      'sellerName': nameController.text.trim(),
      'sellerAvatarUrl': sellerImageUrl,
      'phone': phoneController.text.trim(),
      'address': _completeAddress,
      'status': 'approved',
      'earnings': 0.0,
      'lat': position!.latitude,
      'lng': position!.longitude,
    });
    //save data locally

    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences!.setString('uid', currentUser.uid);
    await sharedPreferences!.setString('email', currentUser.email.toString());
    await sharedPreferences!.setString('name', nameController.text.trim());
    await sharedPreferences!.setString('photoUrl', sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    // tạo một Single Child Scroll View để quản lý thông tin đăng ký nếu quá dài có thể cuộn để xem .
    return SingleChildScrollView(
        child: Container(
            constraints: const BoxConstraints(),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  _getGallery();
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ? Icon(Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey)
                      : null,
                ),
              ),
              //chỉnh dộ cao của từng Form thông tin và thêm thuộc tính cho từng Form Custom Text Field
              SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        data: Icons.person,
                        controller: nameController,
                        hintText: 'Name',
                        isObsecre: false,
                      ),
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
                      CustomTextField(
                        data: Icons.lock,
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        isObsecre: true,
                      ),
                      CustomTextField(
                        data: Icons.phone,
                        controller: phoneController,
                        hintText: 'Phone',
                        isObsecre: false,
                      ),
                      CustomTextField(
                        data: Icons.my_location,
                        controller: locationController,
                        hintText: 'Localtion Address',
                        isObsecre: false,
                      ),

                      // Tạo nút nhấn Icon vị trí để lấy thông tin nhanh vị trí
                      Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ElevatedButton.icon(
                                  label: const Text(
                                    'Get My Location',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () {
                                    getCurrentLocation();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  )),
                              ElevatedButton(
                                onPressed: () {
                                  fromValidation();
                                },
                                child: const Text('Sign Up',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10)),
                              ),
                            ],
                          ))
                    ],
                  )),
            ])));
  }
}
