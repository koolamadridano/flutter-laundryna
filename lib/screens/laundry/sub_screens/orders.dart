import 'package:app/const/color.dart';
import 'package:app/screens/laundry/pages/delivered_orders.dart';
import 'package:app/screens/laundry/pages/inprogress_orders.dart';
import 'package:app/screens/laundry/pages/ready_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LaundryOrders extends StatefulWidget {
  const LaundryOrders({Key? key}) : super(key: key);

  @override
  State<LaundryOrders> createState() => _LaundryOrdersState();
}

class _LaundryOrdersState extends State<LaundryOrders>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  PageController? _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "Orders",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                isScrollable: true,
                labelPadding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                  left: 15.0,
                  right: 15.0,
                ),
                labelStyle: GoogleFonts.chivo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                indicatorWeight: 1,
                physics: const ScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: GoogleFonts.roboto(
                  fontSize: 11,
                ),
                onTap: (index) {
                  _pageController?.jumpToPage(index);
                },
                tabs: [
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "In Progress",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "Ready",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.30,
                    child: const Text(
                      "Delivered",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          LaundryInProgressOrders(),
          LaundryReadyOrders(),
          LaundryDeliveredOrders(),
        ],
      ),
    );
  }
}
