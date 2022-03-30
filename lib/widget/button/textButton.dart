import 'package:app/const/color.dart';
import 'package:app/const/radius.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox defaultButton({action, label}) {
  return SizedBox(
    height: 54,
    width: double.infinity,
    child: TextButton(
      onPressed: () => action(),
      style: TextButton.styleFrom(
        //primary: kFadeWhite,
        backgroundColor: kFadeWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: kRadiusButton,
        ),
      ),
      child: Text(
        label.toString().toUpperCase(),
        style: GoogleFonts.roboto(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: kNavyBlue,
        ),
      ),
    ),
  );
}

SizedBox defaultIconButton({action, label, icon}) {
  return SizedBox(
    height: 54,
    width: double.infinity,
    child: TextButton.icon(
      onPressed: () => action(),
      style: TextButton.styleFrom(
        //primary: kFadeWhite,
        backgroundColor: kFadeWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: kRadiusButton,
        ),
      ),
      icon: icon,
      label: Text(
        label.toString().toUpperCase(),
        style: GoogleFonts.roboto(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: kNavyBlue,
        ),
      ),
    ),
  );
}
