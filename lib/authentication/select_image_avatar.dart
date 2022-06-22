import 'package:flutter/material.dart';

class SelectImageAvatar extends StatefulWidget {
  const SelectImageAvatar({Key? key}) : super(key: key);

  @override
  State<SelectImageAvatar> createState() => _SelectImageAvatarState();
}

class _SelectImageAvatarState extends State<SelectImageAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'Choose Profile Photo',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
            child: Row(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.camera_outlined),
                  onPressed: () {},
                  label: Text('Camera'),
                ),
                TextButton.icon(
                  icon: Icon(Icons.browse_gallery),
                  onPressed: () {},
                  label: Text('Gallery'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
