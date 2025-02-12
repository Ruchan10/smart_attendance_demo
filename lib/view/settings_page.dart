import 'package:Smart_Attendance/core/config.dart';
import 'package:Smart_Attendance/core/snackbar.dart';
import 'package:Smart_Attendance/core/user_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatefulWidget {
  final int? selectedIndex;

  const SettingsPage({
    super.key,
    this.selectedIndex,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? isBiometricEnabled = Config.getBio();
  bool showPwField = false;
  final LocalAuthentication auth = LocalAuthentication();
  TextEditingController userNameController =
      TextEditingController(text: 'test');
  final TextEditingController passwordController =
      TextEditingController(text: 'test');
  bool isObscure = true;
  String initUrl = Config.getHomeUrl();
  UserSharedPrefs usp = UserSharedPrefs();
  _SupportState _supportState = _SupportState.unknown;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF346CB0),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                ListTile(
                  title: const Text(
                    'Dark Mode:',
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Switch(
                    value: false,
                    activeColor: Colors.orange,
                    onChanged: (value) async {
                      showSnackBar(
                        context: context,
                        message: "Working on it.",
                        color: Colors.red,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: showPwField ? 0.0 : 1.0,
                    color: Colors.grey[350],
                  ),
                ),
                Stack(
                  children: [
                    ListTile(
                      title: const Text(
                        'Enable Biometric Authentication:',
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: Switch(
                        value: isBiometricEnabled!,
                        activeColor: Colors.orange,
                        onChanged: (value) async {
                          if (_supportState == _SupportState.unsupported ||
                              _supportState == _SupportState.unknown) {
                            showSnackBar(
                              context: context,
                              message: "Your device does not have biometrics.",
                              color: Colors.red,
                            );
                            return;
                          }
                          if (value == false) {
                            Config.setBio(false);
                          }
                          setState(() {
                            isBiometricEnabled = value;
                            showPwField = value;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: showPwField ? 0.0 : 1.0,
                        color: Colors.grey[350],
                      ),
                    ),
                  ],
                ),
                showPwField
                    ? Column(
                        children: [
                          const SizedBox(height: 28),
                          SizedBox(
                            height: 45,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 7),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(fontSize: 12.0),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2.0),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                print("CLEICNKE: -----------------------");
                                setState(() {
                                  showPwField = false;
                                });
                                showSnackBar(
                                  message: "Biometric authentication enabled",
                                  context: context,
                                );
                                Config.setBio(true);
                                usp.setBio(true);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: const Color(0xFF0286D0),
                              ),
                              child: const Text(
                                "Enable",
                                style: TextStyle(
                                  fontFamily: 'inherit',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity - 40,
                            height: 1.5,
                            color: Colors.grey[350],
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
