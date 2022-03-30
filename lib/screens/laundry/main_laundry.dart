import 'package:app/const/color.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Laundry extends StatefulWidget {
  const Laundry({Key? key}) : super(key: key);

  @override
  State<Laundry> createState() => _LaundryState();
}

class _LaundryState extends State<Laundry> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _order = Get.put(OrderController());

  Map profile = {};
  Map user = {};
  String _toDeleteId = "0";
  late Future<dynamic> _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _order.getOrders(
        accountId: _profile.profile["accountId"],
        accountType: "laundry",
        status: "pending",
      );
    });
  }

  Future<void> onDelete(id) async {
    setState(() {
      _toDeleteId = id;
    });
    await _order.deleteOrder(id);
    refresh();
  }

  void onNavigateToPreviewCustomerOrder(data) {
    //  _laundry.selectedLaundry = data;
    _order.selectedOrder = data;
    Get.toNamed("/preview-customer-order-pending");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // INITIALIZE
    profile = _profile.profile;
    user = _user.userLoginData;
    _orders = _order.getOrders(
      accountId: _profile.profile["accountId"],
      accountType: "laundry",
      status: "pending",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kNavyBlue,
          leading: const SizedBox(),
          leadingWidth: 0.0,
          title: Text(
            "Laundryna",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                splashRadius: 20.0,
                icon: const Icon(
                  AntDesign.menufold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: kNavyBlue),
                currentAccountPictureSize: const Size.square(70.0),
                currentAccountPicture: CircleAvatar(
                  radius: 70.0,
                  backgroundColor: kBabyBlue,
                  backgroundImage: NetworkImage(
                    profile["img"]["avatar"],
                  ),
                ),
                accountName: Text(
                  profile["firstName"] + " " + profile["lastName"],
                  style: GoogleFonts.chivo(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                accountEmail: Text(
                  user["email"],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                onTap: () => Get.toNamed("/laundry-manage"),
                isThreeLine: true,
                leading: const Icon(
                  FontAwesome.cog,
                  color: kCharcoal,
                ),
                title: Text(
                  "Manage",
                  style: GoogleFonts.roboto(
                    color: kCharcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Create Laundry Preferences",
                  style: GoogleFonts.roboto(
                    color: kCharcoal.withOpacity(0.5),
                    fontSize: 12.0,
                  ),
                ),
              ),
              ListTile(
                onTap: () => Get.toNamed("/laundry-orders"),
                isThreeLine: true,
                leading: const Icon(
                  MaterialCommunityIcons.washing_machine,
                  color: kCharcoal,
                ),
                title: Text(
                  "Orders",
                  style: GoogleFonts.roboto(
                    color: kCharcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "View Customer Laundry \nOrders",
                  style: GoogleFonts.roboto(
                    color: kCharcoal.withOpacity(0.5),
                    fontSize: 12.0,
                  ),
                ),
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                onTap: () => _user.onLogout(),
                leading: const Icon(
                  MaterialIcons.logout,
                  size: 22,
                  color: kCharcoal,
                ),
                title: Text(
                  "Logout",
                  style: GoogleFonts.roboto(
                    color: kCharcoal,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
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
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onNavigateToPreviewCustomerOrder(
                        snapshot.data[index],
                      ),
                      contentPadding: EdgeInsets.only(
                        top: index == 0 ? 40.0 : 15,
                        left: 30.0,
                        right: 30.0,
                        bottom: 15.0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: kFadeWhite,
                        backgroundImage: NetworkImage(
                          snapshot.data[index]["header"]["customer"]["avatar"],
                        ),
                        radius: 30.0,
                      ),
                      trailing: _toDeleteId == snapshot.data[index]["_id"]
                          ? const SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 1.5,
                              ),
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () =>
                                  onDelete(snapshot.data[index]["_id"]),
                              child: const Icon(
                                AntDesign.close,
                                color: Colors.red,
                              ),
                            ),
                      title: Container(
                        margin: const EdgeInsets.only(top: 13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index]["header"]["customer"]
                                  ["firstName"],
                              style: GoogleFonts.roboto(
                                color: kCharcoal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                            ),
                            Text(
                              snapshot.data[index]["header"]["customer"]
                                  ["address"],
                              style: GoogleFonts.roboto(
                                color: kCharcoal.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
