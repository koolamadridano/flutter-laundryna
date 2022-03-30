import 'package:flutter/material.dart';
import 'package:app/const/color.dart';
import 'package:app/controllers/laundryController.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LaundyCancelledOrders extends StatefulWidget {
  const LaundyCancelledOrders({Key? key}) : super(key: key);

  @override
  State<LaundyCancelledOrders> createState() => _LaundyCancelledOrdersState();
}

class _LaundyCancelledOrdersState extends State<LaundyCancelledOrders> {
  final _profile = Get.put(ProfileController());
  final _order = Get.put(OrderController());

  late Future<dynamic> _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _order.getOrders(
        accountId: _profile.profile["accountId"],
        accountType: "laundry",
        status: "cancelled",
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orders = _order.getOrders(
      accountId: _profile.profile["accountId"],
      accountType: "laundry",
      status: "cancelled",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _orders,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const LinearProgressIndicator(
              color: kCharcoal,
              minHeight: 2,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              color: kCharcoal,
              minHeight: 2,
            );
          }
          if (snapshot.data == null) {
            return const LinearProgressIndicator(
              color: kCharcoal,
              minHeight: 2,
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
          return RefreshIndicator(
            onRefresh: () => refresh(),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                final _refNumber = snapshot.data[index]["refNumber"];
                final _avatar =
                    snapshot.data[index]["header"]["customer"]["avatar"];
                final _total = snapshot.data[index]["content"]["total"];

                final _customerName =
                    snapshot.data[index]["header"]["customer"]["firstName"];
                final _description =
                    snapshot.data[index]["content"]["description"];
                final _deliveryAddress =
                    snapshot.data[index]["header"]["customer"]["address"];
                final _status = snapshot.data[index]["status"];
                return ListTile(
                  contentPadding: EdgeInsets.only(
                    top: index == 0 ? 40.0 : 20,
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  leading: Hero(
                    tag: _refNumber,
                    child: Image.network(
                      _avatar,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  title: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            _customerName,
                            style: GoogleFonts.chivo(
                              color: kCharcoal,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            _status.toString().toUpperCase(),
                            style: GoogleFonts.roboto(
                              color: kBlueGrotto,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _description,
                          style: GoogleFonts.roboto(
                            color: kCharcoal,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: kFadeWhite,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: snapshot
                                .data[index]["content"]["addOns"].length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, addOnsIndex) {
                              final _title = snapshot.data[index]["content"]
                                  ["addOns"][addOnsIndex]["title"];
                              final _price = snapshot.data[index]["content"]
                                  ["addOns"][addOnsIndex]["price"];
                              return ListTile(
                                dense: true,
                                minLeadingWidth: 25,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 16.0,
                                ),
                                leading: Text(
                                  "${addOnsIndex + 1}.",
                                  style: GoogleFonts.roboto(
                                    color: kCharcoal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                  ),
                                ),
                                title: Text(
                                  _title,
                                  style: GoogleFonts.roboto(
                                    color: kCharcoal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "P$_price.0",
                                  style: GoogleFonts.roboto(
                                    color: kCharcoal.withOpacity(0.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              MaterialCommunityIcons.truck_delivery,
                              color: kCharcoal.withOpacity(0.8),
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "DELIVERY ADDRESS",
                              style: GoogleFonts.roboto(
                                color: kCharcoal.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _deliveryAddress,
                          style: GoogleFonts.roboto(
                            color: kCharcoal.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ORDER # ${_refNumber.toString().toUpperCase()}",
                                style: GoogleFonts.roboto(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                ),
                              ),
                              Text(
                                "TOTAL P$_total.0",
                                style: GoogleFonts.roboto(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
