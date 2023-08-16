// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repo/utils/constants.dart';
import '../../repo/utils/helpers.dart';
import '../../src/providers/constants.dart';
import '../../src/widget/form_and_auth/email_textformfield.dart';
import '../../src/widget/form_and_auth/password_textformfield.dart';
import '../../src/widget/form_and_auth/reusable_authentication_first_half.dart';
import '../../src/widget/section/my_fixed_snackBar.dart';
import '../../theme/colors.dart';
import '../../theme/responsive_constant.dart';
import '../splash_screens/login_splash_screen.dart';
import 'forgot_password.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  final bool logout;
  const Login({super.key, this.logout = false});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLERS ====================================\\

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== BOOL VALUES ====================================\\
  bool isLoading = false;
  bool isChecked = true;
  var isObscured;

  //=========================== STYLE ====================================\\

  TextStyle myAccentFontStyle = TextStyle(
    color: kAccentColor,
  );

  //=========================== FOCUS NODES ====================================\\
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  //=========================== FUNCTIONS ====================================\\
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    await sendPostRequest(emailController.text, passwordController.text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', isChecked);

    setState(() {
      isLoading = false;
    });
  }

  //=========================== REQUEST ====================================\\
  Future<bool> saveUserAndToken(String token) async {
    try {
      final someUserData = await http.get(Uri.parse('$baseURL/auth/'),
          headers: await authHeader(token));
      int userId = jsonDecode(someUserData.body)['id'];

      final userData = await http.get(
          Uri.parse('$baseURL/drivers/getDriver/$userId'),
          headers: await authHeader(token));

      await saveUser(userData.body, token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendPostRequest(String username, String password) async {
    final url = Uri.parse('$baseURL/auth/token');
    final body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(url, body: body);

    dynamic token = jsonDecode(response.body)['token'];

    if (response.statusCode == 200 &&
        token.toString() != false.toString() &&
        await saveUserAndToken(token.toString())) {
      myFixedSnackBar(
        context,
        "Login Successful".toUpperCase(),
        kSuccessColor,
        const Duration(
          seconds: 2,
        ),
      );

      Get.offAll(
        () => const LoginSplashScreen(),
        routeName: 'LoginSplashScreen',
        predicate: (route) => false,
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: true,
        transition: Transition.fadeIn,
      );
    } else {
      myFixedSnackBar(
        context,
        "Invalid email or password".toUpperCase(),
        kAccentColor,
        const Duration(
          seconds: 2,
        ),
      );
    }
  }

  //=========================== INITIAL STATE ====================================\\
  @override
  void initState() {
    super.initState();
    if (widget.logout) {
      deleteUser();
    }
    isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: LayoutGrid(
            columnSizes: breakPointDynamic(
                media.width, [1.fr], [1.fr], [1.fr, 1.fr], [1.fr, 1.fr]),
            rowSizes: [auto, 1.fr],
            children: [
              Column(
                children: [
                  Expanded(
                    child: ReusableAuthenticationFirstHalf(
                      title: "Log In",
                      subtitle: "Please log in to your existing account",
                      decoration: const ShapeDecoration(
                        // color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/logo/benji_red_logo_icon.jpg",
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                      imageContainerHeight:
                          deviceType(media.width) > 2 ? 200 : 88,
                    ),
                  ),
                ],
              ),
              Container(
                height: media.height,
                width: media.width,
                padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(breakPoint(media.width, 24, 24, 0, 0)),
                    topRight:
                        Radius.circular(breakPoint(media.width, 24, 24, 0, 0)),
                  ),
                  color: kPrimaryColor,
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(
                                  0xFF31343D,
                                ),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          EmailTextFormField(
                            controller: emailController,
                            emailFocusNode: emailFocusNode,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              RegExp emailPattern = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                              );
                              if (value == null || value!.isEmpty) {
                                emailFocusNode.requestFocus();
                                return "Enter your email address";
                              } else if (!emailPattern.hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              emailController.text = value;
                            },
                          ),
                          kSizedBox,
                          const SizedBox(
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: Color(
                                  0xFF31343D,
                                ),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          PasswordTextFormField(
                            controller: passwordController,
                            passwordFocusNode: passwordFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: isObscured,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              RegExp passwordPattern = RegExp(
                                r'^.{8,}$',
                              );
                              if (value == null || value!.isEmpty) {
                                passwordFocusNode.requestFocus();
                                return "Enter your password";
                              } else if (!passwordPattern.hasMatch(value)) {
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              passwordController.text = value;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscured = !isObscured;
                                });
                              },
                              icon: isObscured
                                  ? const Icon(
                                      Icons.visibility_off_rounded,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: kSecondaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kHalfSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isChecked,
                              splashRadius: 50,
                              activeColor: kSecondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });
                              },
                            ),
                            const Text(
                              "Remember me ",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => const ForgotPassword(),
                              routeName: 'ForgotPassword',
                              duration: const Duration(milliseconds: 300),
                              fullscreenDialog: true,
                              curve: Curves.easeIn,
                              preventDuplicates: true,
                              popGesture: true,
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Text(
                            "Forgot Password",
                            style: myAccentFontStyle,
                          ),
                        ),
                      ],
                    ),
                    kSizedBox,
                    isLoading
                        ? Center(
                            child: SpinKitChasingDots(
                              color: kAccentColor,
                              duration: const Duration(seconds: 2),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: (() async {
                              if (_formKey.currentState!.validate()) {
                                await loadData();
                              }
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              maximumSize: Size(
                                MediaQuery.of(context).size.width,
                                62,
                              ),
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                60,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              elevation: 10,
                              shadowColor: kDarkGreyColor,
                            ),
                            child: Text(
                              "Log in".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                    kHalfSizedBox,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
