import 'dart:io';
import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterStep4 extends StatefulWidget {
  const RegisterStep4({Key? key}) : super(key: key);

  @override
  State<RegisterStep4> createState() => _RegisterStep4State();
}

class _RegisterStep4State extends State<RegisterStep4> {
  final UserController _user = Get.put(UserController());

  final ImagePicker _picker = ImagePicker();
  String _img1Path = "";
  String _img1Name = "";

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  Future<void> onRegister() async {
    if (_img1Path.isEmpty) {
      return selectImage();
    }
    if (_img1Name.isEmpty) {
      return selectImage();
    }

    _user.userAvatarData["name"] = _img1Name;
    _user.userAvatarData["path"] = _img1Path;

    await _user.onCreateProfile();
    //Get.toNamed("/register-4");
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
          const Icon(
            Entypo.chevron_right,
            color: kNavyBlue,
            size: 15.0,
          ),
          Text(
            _user.userRegistrationProfileData["accoutType"] == "customer"
                ? "Avatar"
                : "Banner",
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
      _user.userRegistrationProfileData["accoutType"] == "customer"
          ? "Profile Avatar"
          : "Laundry Banner",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kNavyBlue,
      ),
    );
    final _subTitle = Text(
      "We are almost done",
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
              const Spacer(flex: 3),
              _user.userRegistrationProfileData["accoutType"] == "customer"
                  ? SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(300)),
                          child: _img1Path == ""
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async => await selectImage(),
                                  child: DottedBorder(
                                    borderType: BorderType.Circle,
                                    dashPattern: const [10, 10],
                                    color: Colors.black12,
                                    strokeWidth: 1.5,
                                    child: Stack(
                                      children: const [
                                        SizedBox(
                                          height: 200,
                                          width: 200,
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              AntDesign.plus,
                                              color: Colors.black12,
                                              size: 34.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => selectImage(),
                                  child: Image.file(
                                    File(_img1Path),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ClipRRect(
                          // borderRadius:
                          //     const BorderRadius.all(Radius.circular(300)),
                          child: _img1Path == ""
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async => await selectImage(),
                                  child: DottedBorder(
                                    borderType: BorderType.Rect,
                                    dashPattern: const [10, 10],
                                    color: Colors.black12,
                                    strokeWidth: 1.5,
                                    child: Stack(
                                      children: const [
                                        SizedBox(
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              AntDesign.plus,
                                              color: Colors.black12,
                                              size: 34.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => selectImage(),
                                  child: Image.file(
                                    File(_img1Path),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "${_user.userRegistrationProfileData["firstName"]}, ${_user.userRegistrationProfileData["lastName"]}",
                  style: GoogleFonts.chivo(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w400,
                    color: kNavyBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  _user.userRegistrationProfileData["address"],
                  style: GoogleFonts.roboto(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w300,
                    color: kNavyBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _user.userRegistrationProfileData["contact"],
                    style: GoogleFonts.robotoMono(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      color: kNavyBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(flex: 8),
              defaultButton(
                action: () => onRegister(),
                label: "Create my account",
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
