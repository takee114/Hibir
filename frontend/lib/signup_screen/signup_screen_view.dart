import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hibir/home_screen/home_screen_view.dart';
import 'package:hibir/loading_screen/loading_screen.dart';
import 'package:hibir/login_screen/login_screen_view.dart';
import 'package:hibir/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hibir/models/api_response.dart';
import 'package:hibir/services/user_service.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password_confirm = TextEditingController();
  final TextEditingController name = TextEditingController();

  bool isLoading = false;

  void _registerUser() async {
    setState(() {
      isLoading = true;
    });

    if (name.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        password_confirm.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('All fields are required');
      return;
    }

    if (password.text != password_confirm.text) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Passwords do not match');
      return;
    }

    ApiResponse response = await register(
        name.text, email.text, password.text, password_confirm.text);

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('${response.error}');
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeView()), (route) => false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  customTextField('Name', name),
                  customTextField('Email', email),
                  customTextField('Password', password, obscureText: true),
                  customTextField('Confirm Password', password_confirm,
                      obscureText: true),
                  SizedBox(
                    height: 10.h,
                  ),
                  customButton(),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'SignIn',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget customTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget customButton() {
    return InkWell(
      onTap: () {
        if (!isLoading) {
          _registerUser();
        }
      },
      child: Container(
        height: 40.h,
        width: 320.w,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
