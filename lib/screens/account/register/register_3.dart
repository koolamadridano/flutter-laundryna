import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStep3 extends StatefulWidget {
  const RegisterStep3({Key? key}) : super(key: key);

  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  final _user = Get.put(UserController());
  String selectedRole = "customer";

  Future<void> onProceed() async {
    // ASSIGN VALUE TO STATE
    _user.userRegistrationProfileData["accoutType"] = selectedRole;

    // NAVIGATE TO STEP 3
    Get.toNamed("/register-4");
    //   await _user.onRegister(email: _email, password: _password);
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
          const Icon(
            Entypo.chevron_right,
            color: kNavyBlue,
            size: 15.0,
          ),
          Text(
            "Type",
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
      "Profile Type",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kNavyBlue,
      ),
    );
    final _subTitle = Text(
      "Tell us what do you want to do and we will set your profile for you",
      style: GoogleFonts.roboto(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: kNavyBlue,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: _breadCrumbs,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const SizedBox(),
          leadingWidth: 0.0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () => Get.back(),
                splashRadius: 20.0,
                icon: const Icon(
                  AntDesign.close,
                  color: kCharcoal,
                ),
              ),
            )
          ],
        ),
        body: Container(
          margin: kDefaultBodyPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title,
              _subTitle,
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: CheckboxListTile(
                  value: selectedRole == "customer" ? true : false,
                  onChanged: (v) {
                    setState(() {
                      selectedRole = "customer";
                    });
                  },
                  title: Text(
                    "Customer",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kNavyBlue,
                    ),
                  ),
                  subtitle: Text(
                    "I'm looking for Laundry Shop nearby",
                    style: GoogleFonts.roboto(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: kNavyBlue,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: CheckboxListTile(
                  value: selectedRole == "laundry" ? true : false,
                  onChanged: (v) {
                    setState(() {
                      selectedRole = "laundry";
                    });
                  },
                  title: Text(
                    "Laundry",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kNavyBlue,
                    ),
                  ),
                  subtitle: Text(
                    "I own a Laundry Shop and I would like to offer my service",
                    style: GoogleFonts.roboto(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: kNavyBlue,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const Spacer(flex: 11),
              defaultButton(
                action: () => onProceed(),
                label: "proceed",
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
