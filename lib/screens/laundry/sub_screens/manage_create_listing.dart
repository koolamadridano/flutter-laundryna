import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/helpers/destroy_inputFocus.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:app/widget/form/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCreateListing extends StatefulWidget {
  const ManageCreateListing({Key? key}) : super(key: key);

  @override
  State<ManageCreateListing> createState() => _ManageCreateListingState();
}

class _ManageCreateListingState extends State<ManageCreateListing> {
  final _listing = Get.put(ListingController());
  late TextEditingController _titleController;
  late FocusNode _titleFocus;
  late TextEditingController _priceController;
  late FocusNode _priceFocus;

  Future<void> onAddListing() async {
    final _title = _titleController.text.trim();
    final _price = _priceController.text.trim();
    if (_title.isEmpty) {
      return _titleFocus.requestFocus();
    }
    if (_price.isEmpty) {
      return _priceFocus.requestFocus();
    }
    await _listing.addListing(
      title: _title,
      price: _price,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _priceController = TextEditingController();
    _priceFocus = FocusNode();
    _titleController = TextEditingController();
    _titleFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
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
            "Create Preferences",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        body: Container(
          padding: kDefaultBodyPadding,
          child: Column(
            children: [
              const Spacer(),
              Container(
                child: inputTextField(
                  labelText: "e.g. Special Fabric",
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
                  controller: _titleController,
                  focusNode: _titleFocus,
                  hasError: false,
                  color: kFadeWhite,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: inputNumberTextField(
                  labelText: "Price",
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
                  controller: _priceController,
                  focusNode: _priceFocus,
                  hasError: false,
                  color: kFadeWhite,
                ),
              ),
              const Spacer(flex: 10),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: defaultButton(
                  action: () => onAddListing(),
                  label: "Add Listing",
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
