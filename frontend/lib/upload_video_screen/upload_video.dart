import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hibir/constant.dart';
import 'package:hibir/home_screen/home_screen_view.dart';
import 'package:hibir/loading_screen/loading_screen.dart';
import 'package:hibir/login_screen/login_screen_view.dart';
import 'package:hibir/models/api_response.dart';
import 'package:hibir/services/post_service.dart';
import 'package:hibir/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class UploadView extends StatefulWidget {
  const UploadView({Key? key}) : super(key: key);

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  final TextEditingController tag = TextEditingController();
  File? videoFile;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  void pickVideo() async {
    final pickedVideo = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedVideo != null) {
      videoFile = File(pickedVideo.path);
      setState(() {});
    }
  }

  void _createPost() async {
    if (videoFile == null || tag.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video and enter a tag')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    ApiResponse response = await createPost(tag.text.trim(), videoFile);

    setState(() {
      isLoading = false;
    });

    if (response.error == null) {
      _showMessage(context, '').then((_) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeView()),
            (route) => false);
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginView()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future<void> _showMessage(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Video Uploaded Successfully'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                'Upload Video',
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
                  onPressed: _createPost,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: pickVideo,
                      child: Text(
                        'Choose Video',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    videoFile != null
                        ? Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Text('Video selected: ${videoFile!.path}'),
                          )
                        : SizedBox(),
                    customTextField('Tag', tag),
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
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
