// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/widget/form_and_auth/password_textformfield.dart';
import '../../src/widget/form_and_auth/reusable_authentication_first_half.dart';
import '../../src/widget/section/my_appbar.dart';
import '../../src/widget/section/my_fixed_snackBar.dart';
import '../../theme/colors.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\

  final TextEditingController _userPasswordEC = TextEditingController();
  final TextEditingController _confirmPasswordEC = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  final FocusNode _userPasswordFN = FocusNode();
  final FocusNode _confirmPasswordFN = FocusNode();

  //=========================== BOOL VALUES====================================\\
  bool _isLoading = false;
  bool _validAuthCredentials = false;
  bool isPWSuccess = false;
  var _isObscured;

  //=========================== FUNCTIONS ====================================\\
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulating a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _validAuthCredentials = true;
    });

    //Display snackBar
    myFixedSnackBar(
      context,
      "Password Reset successful",
      kSuccessColor,
      const Duration(
        seconds: 2,
      ),
    );

    // Simulating a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the new page
    Get.offAll(
      () => const Login(),
      routeName: 'Login',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      popGesture: true,
      transition: Transition.rightToLeft,
    );

    setState(() {
      _isLoading = false;
    });
  }

  //=========================== STATES ====================================\\

  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: const MyAppBar(
          title: "",
          elevation: 0.0,
          actions: [],
          backgroundColor: kTransparentColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: LayoutGrid(
            columnSizes: breakPointDynamic(
                media.size.width, [1.fr], [1.fr], [1.fr, 1.fr], [1.fr, 1.fr]),
            rowSizes: [auto, 1.fr],
            children: [
              Column(
                children: [
                  Expanded(
                    child: () {
                      if (_validAuthCredentials) {
                        return ReusableAuthenticationFirstHalf(
                          title: "Reset Password",
                          subtitle:
                              "Just enter a new password here and you are good to go!",
                          curves: Curves.easeInOut,
                          duration: const Duration(),
                          containerChild: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: kSuccessColor,
                              size: 80,
                            ),
                          ),
                          decoration: ShapeDecoration(
                              color: kPrimaryColor, shape: const OvalBorder()),
                          imageContainerHeight:
                              deviceType(media.size.width) > 2 ? 200 : 100,
                        );
                      } else {
                        return ReusableAuthenticationFirstHalf(
                          title: "Reset Password",
                          subtitle:
                              "Just enter a new password here and you are good to go!",
                          curves: Curves.easeInOut,
                          duration: const Duration(),
                          containerChild: Center(
                            child: FaIcon(
                              FontAwesomeIcons.rotateLeft,
                              color: kSecondaryColor,
                              size: 80,
                            ),
                          ),
                          decoration: ShapeDecoration(
                              color: kPrimaryColor, shape: const OvalBorder()),
                          imageContainerHeight:
                              deviceType(media.size.width) > 2 ? 200 : 100,
                        );
                      }
                    }(),
                  ),
                ],
              ),
              Container(
                height: media.size.height,
                width: media.size.width,
                padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        breakPoint(media.size.width, 24, 24, 0, 0)),
                    topRight: Radius.circular(
                        breakPoint(media.size.width, 24, 24, 0, 0)),
                  ),
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Enter New Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          PasswordTextFormField(
                            controller: _userPasswordEC,
                            passwordFocusNode: _userPasswordFN,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isObscured,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              RegExp passwordPattern = RegExp(
                                r'^.{8,}$',
                              );
                              if (value == null || value == '') {
                                _userPasswordFN.requestFocus();
                                return "Enter your password";
                              } else if (!passwordPattern.hasMatch(value)) {
                                _userPasswordFN.requestFocus();
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPasswordEC.text = value;
                            },
                            suffixIcon: const IconButton(
                              onPressed: null,
                              icon: Icon(null),
                            ),
                          ),
                          kSizedBox,
                          kHalfSizedBox,
                          FlutterPwValidator(
                            uppercaseCharCount: 1,
                            lowercaseCharCount: 1,
                            numericCharCount: 1,
                            controller: _userPasswordEC,
                            width: 400,
                            height: 150,
                            minLength: 8,
                            onSuccess: () {
                              setState(() {
                                isPWSuccess = true;
                              });
                              myFixedSnackBar(
                                context,
                                "Password matches requirement",
                                kSuccessColor,
                                const Duration(
                                  seconds: 1,
                                ),
                              );
                            },
                            onFail: () {
                              setState(() {
                                isPWSuccess = false;
                              });
                            },
                          ),
                          kSizedBox,
                          const SizedBox(
                            child: Text(
                              'Confirm Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          PasswordTextFormField(
                            controller: _confirmPasswordEC,
                            passwordFocusNode: _confirmPasswordFN,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isObscured,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              RegExp passwordPattern = RegExp(
                                r'^.{8,}$',
                              );
                              if (value == null || value == '') {
                                _confirmPasswordFN.requestFocus();
                                return "Confirm your password";
                              }
                              if (value != _userPasswordEC.text) {
                                return "Password does not match";
                              } else if (!passwordPattern.hasMatch(value)) {
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _confirmPasswordEC.text = value;
                            },
                            suffixIcon: const IconButton(
                              onPressed: null,
                              icon: Icon(null),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kSizedBox,
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: (() async {
                              if (_formKey.currentState!.validate()) {
                                loadData();
                              }
                            }),
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: kAccentColor,
                              fixedSize: Size(media.size.width, 50),
                            ),
                            child: Text(
                              'Save'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                    kSizedBox,
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
