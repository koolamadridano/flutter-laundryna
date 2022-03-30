import 'package:app/const/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LaundryOrderHistory extends StatefulWidget {
  const LaundryOrderHistory({Key? key}) : super(key: key);

  @override
  State<LaundryOrderHistory> createState() => _LaundryOrderHistoryState();
}

class _LaundryOrderHistoryState extends State<LaundryOrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kNavyBlue,
        leading: IconButton(
          onPressed: () => Get.back(),
          splashRadius: 20.0,
          icon: const Icon(
            AntDesign.arrowleft,
            color: Colors.white,
          ),
        ),
        title: Text(
          "History",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        actions: [],
      ),
      body: Container(),
    );
  }
}
