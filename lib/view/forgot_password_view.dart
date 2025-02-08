import 'package:Smart_Attendance/core/app_routes.dart';
import 'package:Smart_Attendance/core/config.dart';
import 'package:Smart_Attendance/core/loading_indicator.dart';
import 'package:Smart_Attendance/core/snackbar.dart';
import 'package:Smart_Attendance/model/changepw_model.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

final TextEditingController userNameController =
    TextEditingController(text: 'test');
final TextEditingController newPwController =
    TextEditingController(text: 'test');
final TextEditingController confirmNewPwController =
    TextEditingController(text: 'test');
final TextEditingController otpController = TextEditingController(text: 'test');

class _ForgotPasswordState extends State<ForgotPassword> {
  int page = 0;
  String initUrl = Config.getHomeUrl();
  bool isObscure = true;
  bool isObscure0 = true;
  bool isLoading = false;

  Future<bool> checkEmail(String mail, BuildContext context) async {
    return true;
  }

  Future<bool> checkOtp(String otp, String email) async {
    return true;
  }

  Future<bool> changePassword(
    PasswordModel model,
  ) async {
    return true;
  }

  Widget forgotPw() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Column(
            children: [
              Image.asset(
                Config.getSplashImage(),
                height: 71,
                width: 152,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        const SizedBox(height: 140),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Forgot password? Provide your ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: userNameController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
            suffixIcon: Icon(Icons.email_outlined),
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            String email = userNameController.text.trim();
            if (email.isEmpty) {
              showSnackBar(
                context: context,
                message: "Please enter your email.",
                color: Colors.red,
              );
            } else {
              setState(() {
                isLoading = true;
              });

              bool? hasEmail = await checkEmail(email, context);
              setState(() {
                isLoading = false;
              });

              if (hasEmail) {
                setState(() {
                  page = 1;
                });
              }
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: const Color(0xFF0286D0),
          ),
          child: const Text(
            "Submit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget enterOtp() {
    String email = userNameController.text.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Column(
            children: [
              Image.asset(
                Config.getSplashImage(),
                height: 71,
                width: 152,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        const SizedBox(height: 140),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'An email contining OTP has been sent to ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: '.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: otpController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
            suffixIcon: Icon(Icons.email_outlined),
            hintText: 'Enter OPT sent to your email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            String otp = otpController.text.trim();
            String email = userNameController.text.trim();
            if (otp.isEmpty) {
              showSnackBar(
                context: context,
                message: "Please enter your otp.",
                color: Colors.red,
              );
              return;
            }
            setState(() {
              isLoading = true;
            });
            bool? isOtp = await checkOtp(otp, email);
            setState(() {
              isLoading = false;
            });
            if (isOtp) {
              setState(() {
                page = 2;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: const Color(0xFF0286D0),
          ),
          child: const Text(
            "Change",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget newPw() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Column(
            children: [
              Image.asset(
                Config.getSplashImage(),
                height: 71,
                width: 152,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        const SizedBox(height: 140),
        TextFormField(
          controller: newPwController,
          obscureText: isObscure,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 7),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            ),
            hintText: 'New Password',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: confirmNewPwController,
          obscureText: isObscure,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 7),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure0 ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            ),
            hintText: 'Confirm New Password',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            String email = userNameController.text.trim();
            String pw = newPwController.text.trim();
            String cpw = confirmNewPwController.text.trim();
            if (pw.isEmpty || cpw.isEmpty) {
              showSnackBar(
                context: context,
                message: "Fields cannot be empty.",
                color: Colors.red,
              );
              return;
            }
            if (pw != cpw) {
              showSnackBar(
                context: context,
                message: "Passwords do not match.",
                color: Colors.red,
              );
              return;
            }
            PasswordModel pm = PasswordModel(
                email: email, password: pw, password_confirmation: cpw);
            setState(() {
              isLoading = true;
            });
            bool? hasChanged = await changePassword(pm);
            setState(() {
              isLoading = false;
            });
            if (hasChanged) {
              Navigator.popAndPushNamed(context, AppRoute.loginRoute);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: const Color(0xFF0286D0),
          ),
          child: const Text(
            "Change",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: (page == 0)
                      ? forgotPw()
                      : (page == 1)
                          ? enterOtp()
                          : newPw(),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CustomLoadingIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
