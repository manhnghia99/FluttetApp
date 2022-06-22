import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
//khai báo biến thuộc tính method controller, data, hinText, isObscre, enabled cho Widget Form và truyền thuộc tính vào lớp CustomTextField
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;
  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    // tạo UI và truyền thuộc tính vào TextFormField cho người nhập thông tin vào ô trống
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(10),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: isObsecre!,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              data,
              color: Colors.greenAccent,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText,
          ),
        ));
  }
}
