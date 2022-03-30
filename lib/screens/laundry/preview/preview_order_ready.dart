import 'package:app/const/color.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/widget/button/textButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class PreviewCustomerReadyOrder extends StatefulWidget {
  const PreviewCustomerReadyOrder({Key? key}) : super(key: key);

  @override
  State<PreviewCustomerReadyOrder> createState() =>
      _PreviewCustomerReadyOrderState();
}

class _PreviewCustomerReadyOrderState extends State<PreviewCustomerReadyOrder> {
  final tooltipController = JustTheController();

  final _order = Get.put(OrderController());
  bool onUpdateStatusIsOngoing = false;
  late String selectedValue;

  Future<void> onCallNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  Future<void> onUpdateStatus() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
        height: Get.height * 0.40,
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "UPDATE STATUS TO \n\"DELIVERED?",
              style: GoogleFonts.chivo(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
                color: kNavyBlue,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                "This Order Detail will be moved to \nDelivered Screen",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: kNavyBlue.withOpacity(0.5),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              width: Get.width * 0.40,
              child: Row(
                children: [
                  Expanded(
                    child: defaultButton(
                      action: () async {
                        Get.back();
                        Future.delayed(const Duration(milliseconds: 200),
                            () async {
                          setState(() => onUpdateStatusIsOngoing = true);
                          await _order.updateOrderStatus(
                            id: _order.selectedOrder["_id"],
                            status: "delivered",
                          );
                          Get.toNamed("/laundry-orders");
                          setState(() => onUpdateStatusIsOngoing = false);
                        });
                      },
                      label: "Yes",
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: defaultButton(
                      action: () => Get.back(),
                      label: "No",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      isDismissible: false,
      isScrollControlled: false,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue = _order.selectedOrder["status"];

    Future.delayed(const Duration(milliseconds: 500), () {
      tooltipController.showTooltip(immediately: false);
      Future.delayed(const Duration(seconds: 5), () {
        tooltipController.hideTooltip(immediately: false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tooltipController.hideTooltip(immediately: false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kNavyBlue,
          leading: IconButton(
            onPressed: () => Get.toNamed("/laundry"),
            splashRadius: 20.0,
            icon: const Icon(
              AntDesign.arrowleft,
              color: Colors.white,
            ),
          ),
          title: SizedBox(
            width: 230,
            child: Text(
              "Order Detail",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          actions: [
            JustTheTooltip(
              controller: tooltipController,
              backgroundColor: kBlueGrotto,
              fadeInDuration: const Duration(milliseconds: 500),
              fadeOutDuration: const Duration(milliseconds: 500),
              barrierDismissible: false,
              tailLength: 20,
              tailBaseWidth: 20,
              offset: -5,
              isModal: true,
              child: onUpdateStatusIsOngoing
                  ? IconButton(
                      onPressed: () {},
                      splashRadius: 20.0,
                      icon: const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : IconButton(
                      onPressed: () => onUpdateStatus(),
                      splashRadius: 20.0,
                      icon: const Icon(
                        AntDesign.arrowright,
                        color: Colors.white,
                      ),
                    ),
              content: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Tap this forward arrow if the order \nhas been DELIVERED',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => onCallNumber(
                _order.selectedOrder["header"]["customer"]["contactNo"],
              ),
              splashRadius: 20,
              icon: const Icon(
                FontAwesome.phone_square,
                color: Colors.white,
              ),
            ),
          ],
          bottom: PreferredSize(
            child: Container(
              padding: const EdgeInsets.only(top: 20.0),
              color: kFadeWhite,
              height: 240,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: kFadeWhite,
                      backgroundImage: NetworkImage(
                        _order.selectedOrder["header"]["customer"]["avatar"],
                      ),
                      radius: 30.0,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _order.selectedOrder["header"]["customer"]
                                      ["firstName"],
                                  style: GoogleFonts.roboto(
                                    color: kCharcoal,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                _order.selectedOrder["status"]
                                    .toString()
                                    .toUpperCase(),
                                style: GoogleFonts.chivo(
                                  color: kBlueGrotto,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Row(
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
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _order.selectedOrder["header"]["customer"]
                                ["address"],
                            style: GoogleFonts.roboto(
                              color: kCharcoal,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 55.0,
                            margin: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: Text(
                              _order.selectedOrder["content"]["description"],
                              style: GoogleFonts.roboto(
                                color: kCharcoal.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: const Divider(),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "TOTAL kg",
                                style: GoogleFonts.chivo(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.0,
                                ),
                              ),
                              Text(
                                _order.selectedOrder["content"]["weight"],
                                style: GoogleFonts.chivo(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "SUBTOTAL",
                                style: GoogleFonts.chivo(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.0,
                                ),
                              ),
                              Text(
                                "P${_order.selectedOrder["content"]["total"]}.0",
                                style: GoogleFonts.chivo(
                                  color: kCharcoal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(240),
          ),
        ),
        body: ListView.builder(
          itemCount: _order.selectedOrder["content"]["addOns"].length,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              dense: true,
              minLeadingWidth: 25,
              contentPadding: EdgeInsets.only(
                top: index == 0 ? 40.0 : 10,
                left: 30.0,
                right: 30.0,
              ),
              leading: Text(
                "${index + 1}.",
                style: GoogleFonts.roboto(
                  color: kCharcoal,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                ),
              ),
              title: Text(
                _order.selectedOrder["content"]["addOns"][index]["title"],
                style: GoogleFonts.roboto(
                  color: kCharcoal,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
              subtitle: Text(
                "P${_order.selectedOrder["content"]["addOns"][index]["price"]}.0",
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
    );
  }
}
