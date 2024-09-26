import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hibir/const.dart';
import 'package:hibir/home_screen/home_screen_view.dart';
import 'package:hibir/loading_screen/loading_screen.dart';
// import 'package:hibir/model_classes/user_model.dart';

class EditView extends StatefulWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController addLink = TextEditingController();
  File? profileImage;
  bool isLoading = false;

  void onSaveData() async {
    setState(() {
      isLoading = true;
    });
    if (name.text.isNotEmpty && username.text.isNotEmpty) {
      String profileImageUrl = "";
      if (profileImage != null) {
        String imageId = generateId();
      }

      Map<String, dynamic> userData = {
        'name': name.text,
        'username': username.text,
        'bio': bio.text,
        'add_link': addLink.text,
        'profile_image': profileImageUrl.isNotEmpty ? profileImageUrl : "",
      };

      setState(() {
        isLoading = false;
      });
    } else {
      print('Username & name is required');
    }
  }

  void pickImage() async {
    final pickedImage = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDetail();
  }

  void setDetail() async {
    // name.text = widget.userModel.name;
    // username.text = widget.userModel.username;
    // bio.text = widget.userModel.bio;
    // addLink.text = widget.userModel.addLink;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    onSaveData();
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 90.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: profileImage != null
                                ? FileImage(profileImage!) as ImageProvider
                                : NetworkImage(
                                    'widget.userModel.profileImage',
                                  )),
                      ),
                      // child: Icon(
                      //   Icons.account_circle_sharp,
                      // size: 90.sp,
                      // ),
                    ),
                    TextButton(
                      onPressed: () {
                        pickImage();
                      },
                      child: Text(
                        'Change profile picture',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    customTextField('Name', name),
                    // customTextField('Username', username),
                    // customTextField('Bio', bio),
                    // customTextField('Add Link', addLink),
                  ],
                ),
              ),
            ),
          );
  }

  Widget customTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }
}
