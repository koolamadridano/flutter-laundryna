import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/const/radius.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/destroy_inputFocus.dart';
import 'package:app/widget/form/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _user = Get.put(UserController());

  late TextEditingController _emailController;
  late FocusNode _emailFocus;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocus;

  Future<void> onLogin() async {
    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();

    // VALIDATE
    if (_email.isEmpty) {
      return _emailFocus.requestFocus();
    }
    if (_password.isEmpty) {
      return _passwordFocus.requestFocus();
    }

    // LOGIN
    await _user.onLogin(email: _email, password: _password);
  }

  void onNavigate() {
    _user.loginFailed.value = false;
    Get.toNamed("/register");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "Laundryna Account Login",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kNavyBlue,
      ),
    );
    final _subTitle = Text(
      "To continue, please enter a valid email and password.",
      style: GoogleFonts.roboto(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: kNavyBlue,
      ),
    );
    final _registerAccount = Container(
      margin: const EdgeInsets.only(top: 25.0),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => onNavigate(),
        behavior: HitTestBehavior.opaque,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Don't have an account?",
            style: GoogleFonts.roboto(
              color: kCharcoal,
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: " SIGN UP!",
                style: GoogleFonts.roboto(
                  color: kBlueGrotto,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        ),
      ),
    );
    final _errorMessage = Container(
      margin: const EdgeInsets.only(top: 15.0, bottom: 15),
      child: Text(
        "Oops! Seems like the Email and/or the Password you have entered is incorrect.",
        style: GoogleFonts.roboto(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Colors.red,
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
          onTap: () => destroyTextFieldFocus(context),
          child: Obx(
            () => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Container(
                padding: kDefaultBodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _title,
                    _subTitle,
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 30.0),
                      child: inputTextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        color: kFadeWhite,
                        hasError: _user.loginFailed.value,
                        labelText: "Email",
                        textFieldStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kNavyBlue,
                        ),
                        hintStyleStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kNavyBlue,
                        ),
                      ),
                    ),
                    _user.loginFailed.value ? _errorMessage : const SizedBox(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10.0),
                      child: inputTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: true,
                        color: kFadeWhite,
                        hasError: _user.loginFailed.value,
                        labelText: "Password",
                        textFieldStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kNavyBlue,
                        ),
                        hintStyleStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kNavyBlue,
                        ),
                      ),
                    ),
                    const Spacer(flex: 7),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: TextButton(
                        onPressed: () => onLogin(),
                        style: TextButton.styleFrom(
                          //primary: kFadeWhite,
                          backgroundColor: kFadeWhite,
                          shape: const RoundedRectangleBorder(
                            borderRadius: kRadiusButton,
                          ),
                        ),
                        child: Text(
                          "LOGIN",
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: kNavyBlue,
                          ),
                        ),
                      ),
                    ),
                    _registerAccount,
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
