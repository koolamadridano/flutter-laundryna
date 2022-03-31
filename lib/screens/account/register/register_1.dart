import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/destroy_inputFocus.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:app/widget/form/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _user = Get.put(UserController());

  late TextEditingController _emailController;
  late FocusNode _emailFocus;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocus;

  bool _isAgreed = false;

  Future<void> onProceed() async {
    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();

    // VALIDATE
    if (_email.isEmpty) {
      return _emailFocus.requestFocus();
    }
    if (_password.isEmpty) {
      return _passwordFocus.requestFocus();
    }

    await _user.onRegister(email: _email, password: _password);
  }

  void onNavigate() {
    Get.toNamed("/login");
    // RESET
    _user.registerFailed.value = false;
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
      "Welcome to Laundrynaa!",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kNavyBlue,
      ),
    );
    final _subTitle = Text(
      "Before we start, please enter your email and password.",
      style: GoogleFonts.roboto(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: kNavyBlue,
      ),
    );
    final _loginAccount = Container(
      margin: const EdgeInsets.only(top: 25.0),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => onNavigate(),
        behavior: HitTestBehavior.opaque,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Already have an account?',
            style: GoogleFonts.roboto(
              color: kCharcoal,
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: ' SIGN IN!',
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
        "Oops! Seems like the Email you have entered is currently in \nused, please try signing in instead.",
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
                margin: kDefaultBodyPadding,
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
                        hasError: _user.registerFailed.value,
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
                    _user.registerFailed.value
                        ? _errorMessage
                        : const SizedBox(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10.0),
                      child: inputTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: true,
                        labelText: "Password",
                        color: kFadeWhite,
                        hasError: _user.registerFailed.value,
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
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: CheckboxListTile(
                        value: _isAgreed,
                        onChanged: (v) {
                          setState(() {
                            _isAgreed = v as bool;
                          });
                        },
                        title: Text(
                          "By clicking Proceed you agree to Laundrynaa Terms of Service, Privacy Policy, and to receive important emails about my account.",
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: kNavyBlue,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const Spacer(flex: 6),
                    IgnorePointer(
                      ignoring: _isAgreed ? false : true,
                      child: AnimatedOpacity(
                        opacity: _isAgreed ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: SizedBox(
                          height: 54,
                          width: double.infinity,
                          child: defaultButton(
                            action: () => onProceed(),
                            label: "proceed",
                          ),
                        ),
                      ),
                    ),
                    _loginAccount,
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
