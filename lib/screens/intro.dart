import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  void onNavigate() {
    Get.toNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: kDefaultBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text("Welcome Back \nto Laundryna",
                style: GoogleFonts.lilitaOne(
                  fontSize: 45.0,
                  height: 0.8,
                  color: kNavyBlue,
                )),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(
                "Fastest, Easiest and Affordable",
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kNavyBlue,
                ),
              ),
            ),
            const Spacer(flex: 7),
            TextButton.icon(
              onPressed: () => onNavigate(),
              style: ElevatedButton.styleFrom(
                //primary: const Color.fromARGB(255, 250, 250, 250),
                //elevation: 0,
                alignment: Alignment.center,
              ),
              icon: const Icon(
                AntDesign.arrowright,
                color: kCharcoal,
                size: 14.0,
              ),
              label: Text(
                "Next",
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kNavyBlue,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
