import 'package:app/const/color.dart';
import 'package:app/const/margin.dart';
import 'package:app/controllers/laundryController.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/destroy_inputFocus.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:app/widget/form/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PreviewLaundry extends StatefulWidget {
  const PreviewLaundry({Key? key}) : super(key: key);

  @override
  State<PreviewLaundry> createState() => _PreviewLaundryState();
}

class _PreviewLaundryState extends State<PreviewLaundry> {
  final _profile = Get.put(ProfileController());
  final _laundry = Get.put(LaundryController());
  final _listings = Get.put(ListingController());
  final _order = Get.put(OrderController());

  late TextEditingController _descriptionController;
  late FocusNode _descriptionFocus;

  late bool sticky;

  List<String> selectedPreferencesId = [];
  List<dynamic> selectedPreferences = [];
  int selectedPreferencesTotal = 60;
  int defaultKiloPrice = 60;
  double selectedKilo = 4;

  late Future<dynamic> _laundryListings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // INITIALIZE CONTROLLERS
    _descriptionController = TextEditingController();
    _descriptionFocus = FocusNode();

    // INITIALIZE VARIABLES
    sticky = true;
    _laundryListings = _listings.getLaundryListings(
      availability: true,
      accountId: _laundry.selectedLaundry["accountId"],
    );
  }

  Future<void> refresh() async {
    setState(() {
      _laundryListings = _listings.getLaundryListings(
        availability: true,
        accountId: _laundry.selectedLaundry["accountId"],
      );
    });
  }

  void onSelect(data) {
    if (!selectedPreferencesId.contains(data["_id"])) {
      setState(() {
        selectedPreferences.add(data);
        selectedPreferencesId.add(data["_id"]);
        selectedPreferencesTotal += int.parse(data["price"]);
      });
      return;
    }
    if (selectedPreferencesId.contains(data["_id"])) {
      setState(() {
        selectedPreferences.removeWhere(
          (element) => element["_id"] == data["_id"],
        );
        selectedPreferencesId.remove(data["_id"]);
        selectedPreferencesTotal -= int.parse(data["price"]);
      });
      return;
    }
  }

  Future<void> onCallNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  Future<void> onCreateOrder() async {
    final _description = _descriptionController.text.trim();
    if (_description.isEmpty) {
      return _descriptionFocus.requestFocus();
    }
    Map data = {
      "header": {
        "customer": {
          "accountId": _profile.profile["accountId"],
          "firstName": _profile.profile["firstName"],
          "lastName": _profile.profile["lastName"],
          "contactNo": _profile.profile["contact"]["number"],
          "address": _profile.profile["address"]["name"],
          "avatar": _profile.profile["img"]["avatar"]
        },
        "laundry": {
          "accountId": _laundry.selectedLaundry["accountId"],
          "name": _laundry.selectedLaundry["firstName"],
          "contactNo": _laundry.selectedLaundry["contact"]["number"],
          "address": _laundry.selectedLaundry["address"]["name"],
          "banner": _laundry.selectedLaundry["img"]["avatar"],
        }
      },
      "content": {
        "addOns": selectedPreferences,
        "description": _description,
        "weight": "${selectedKilo.round()} kg",
        "total": "$selectedPreferencesTotal"
      },
      "status": "pending"
    };
    await _order.createOrder(data);
  }

  void onChangeSitckyness() {
    setState(() {
      sticky = !sticky;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              expandedHeight: 150,
              stretch: true,
              backgroundColor: kNavyBlue,
              pinned: true,
              leading: IconButton(
                onPressed: () => Get.back(),
                splashRadius: 20.0,
                icon: const Icon(
                  AntDesign.arrowleft,
                  color: Colors.white,
                ),
              ),
              title: Text(
                _laundry.selectedLaundry["firstName"],
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: _laundry.selectedLaundry["accountId"],
                  child: Image.network(
                    _laundry.selectedLaundry["img"]["avatar"],
                    fit: BoxFit.cover,
                  ),
                ),
                stretchModes: const [
                  StretchMode.blurBackground,
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () => onChangeSitckyness(),
                    splashRadius: 20,
                    icon: Icon(
                      MaterialIcons.push_pin,
                      color: sticky ? kBabyBlue : Colors.white,
                    )),
                IconButton(
                  onPressed: () => onCallNumber(
                    _laundry.selectedLaundry["contact"]["number"],
                  ),
                  splashRadius: 20,
                  icon: const Icon(
                    FontAwesome.phone_square,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SliverStickyHeader(
              sticky: sticky,
              header: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: kElevationToShadow[3],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: kDefaultBodyPadding.copyWith(top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "P15/kg",
                            style: GoogleFonts.chivo(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: kNavyBlue,
                            ),
                          ),
                          Text(
                            "PHP $selectedPreferencesTotal.0",
                            style: GoogleFonts.chivo(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: kNavyBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: kDefaultBodyPadding.copyWith(
                        top: 20.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: SfSlider(
                        min: 1,
                        max: 8.0,
                        value: selectedKilo,
                        interval: 1,
                        shouldAlwaysShowTooltip: true,
                        showTicks: true,
                        stepSize: 1,
                        showLabels: true,
                        enableTooltip: true,
                        activeColor: kNavyBlue,
                        inactiveColor: kBabyBlue,
                        onChanged: (value) {},
                        onChangeEnd: (dynamic value) {
                          double _kg = value;
                          int kilo = _kg.round();
                          setState(() {
                            selectedPreferencesId.clear();
                            selectedPreferencesTotal = 0;
                            selectedKilo = value;
                            selectedPreferencesTotal += kilo * 15;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: kDefaultBodyPadding.copyWith(
                        top: 20.0,
                      ),
                      child: inputTextArea(
                        controller: _descriptionController,
                        focusNode: _descriptionFocus,
                        labelText: "Description",
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
                        hasError: false,
                        color: kFadeWhite,
                      ),
                    ),
                    Container(
                      margin: kDefaultBodyPadding.copyWith(
                        top: 20.0,
                        bottom: 10.0,
                      ),
                      child: defaultIconButton(
                        action: () => onCreateOrder(),
                        icon: const Icon(
                          MaterialCommunityIcons.washing_machine,
                          color: kNavyBlue,
                          size: 17.0,
                        ),
                        label: "order",
                      ),
                    ),
                  ],
                ),
              ),
              sliver: SliverFillRemaining(
                child: FutureBuilder(
                    future: _laundryListings,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kCharcoal,
                            strokeWidth: 2,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kCharcoal,
                            strokeWidth: 2,
                          ),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kCharcoal,
                            strokeWidth: 2,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data.length == 0) {
                          return Center(
                            child: Text(
                              "EMPTY",
                              style: GoogleFonts.roboto(
                                color: kCharcoal.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0,
                              ),
                            ),
                          );
                        }
                      }

                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            child: CheckboxListTile(
                              value: selectedPreferencesId.contains(
                                snapshot.data[index]["_id"],
                              ),
                              onChanged: (v) {
                                onSelect(
                                  snapshot.data[index],
                                );
                              },
                              title: Text(
                                snapshot.data[index]["title"],
                                style: GoogleFonts.chivo(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                ),
                              ),
                              subtitle: Text(
                                "P${snapshot.data[index]["price"]}.0",
                                style: GoogleFonts.robotoMono(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
