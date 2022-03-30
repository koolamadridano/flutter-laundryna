import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/destroy_inputFocus.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:app/widget/form/input.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({Key? key}) : super(key: key);

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _user = Get.put(UserController());

  late TextEditingController _firstNameController;
  late FocusNode _firstNameFocus;

  late TextEditingController _lastNameController;
  late FocusNode _lastNameFocus;

  late TextEditingController _contactController;
  late FocusNode _contactFocus;

  late TextEditingController _addressController;
  late FocusNode _addressFocus;

  Future<void> onProceed() async {
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _address = _addressController.text.trim();
    final _contact = _contactController.text.trim().replaceAll(r' ', "");

    // VALIDATE
    if (_firstName.isEmpty) {
      return _firstNameFocus.requestFocus();
    }
    if (_lastName.isEmpty) {
      return _lastNameFocus.requestFocus();
    }
    if (_contact.isEmpty) {
      return _contactFocus.requestFocus();
    }
    if (_address.isEmpty) {
      return _addressFocus.requestFocus();
    }

    // ASSIGN VALUE TO STATE
    _user.userRegistrationProfileData["firstName"] = _firstName;
    _user.userRegistrationProfileData["lastName"] = _lastName;
    _user.userRegistrationProfileData["address"] = _address;
    _user.userRegistrationProfileData["contact"] = _contact;

    // NAVIGATE TO STEP 3
    Get.toNamed("/register-3");
    //   await _user.onRegister(email: _email, password: _password);
  }

  void onNavigate() {
    Get.toNamed("/login");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocus = FocusNode();
    _lastNameController = TextEditingController();
    _lastNameFocus = FocusNode();
    _contactController = MaskedTextController(mask: '0000 000 0000');
    _contactFocus = FocusNode();
    _addressController = TextEditingController();
    _addressFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameController.dispose();
    _lastNameFocus.dispose();
    _contactController.dispose();
    _contactFocus.dispose();
    _addressController.dispose();
    _addressFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _breadCrumbs = Container(
      margin: kDefaultBodyPadding.copyWith(left: 15.0),
      child: Row(
        children: [
          Text(
            "Account",
            style: GoogleFonts.roboto(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kNavyBlue,
              height: 1.5,
            ),
          ),
          const Icon(
            Entypo.chevron_right,
            color: kNavyBlue,
            size: 15.0,
          ),
          Text(
            "Basic Info",
            style: GoogleFonts.roboto(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kNavyBlue,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
    final _title = Text(
      "Profile Basic Info",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kNavyBlue,
      ),
    );
    final _subTitle = Text(
      "Let us know each other",
      style: GoogleFonts.roboto(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: kNavyBlue,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: _breadCrumbs,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox(),
            leadingWidth: 0.0,
          ),
          body: Container(
            margin: kDefaultBodyPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title,
                _subTitle,
                Container(
                  margin: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: inputTextField(
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          color: kFadeWhite,
                          hasError: false,
                          labelText: "Firstname",
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
                      const SizedBox(width: 5),
                      Expanded(
                        child: inputTextField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocus,
                          hasError: false,
                          labelText: "Lastname",
                          color: kFadeWhite,
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
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputNumberTextField(
                    controller: _contactController,
                    focusNode: _contactFocus,
                    hasError: false,
                    labelText: "Contact Number",
                    color: kFadeWhite,
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
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputTextArea(
                    controller: _addressController,
                    focusNode: _addressFocus,
                    // obscureText: true,
                    hasError: false,
                    labelText: "Delivery Address",
                    color: kFadeWhite,
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
                const Spacer(flex: 10),
                defaultButton(
                  action: () => onProceed(),
                  label: "proceed",
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
