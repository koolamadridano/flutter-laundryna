import 'package:app/const/color.dart';
import 'package:app/controllers/laundryController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _laundry = Get.put(LaundryController());

  late Future<dynamic> _laundries;

  Map profile = {};
  Map user = {};

  Future<void> refresh() async {
    setState(() {
      _laundries = _profile.getLaundries();
    });
  }

  void onNavigateToPreviewLaundry(data) {
    _laundry.selectedLaundry = data;
    Get.toNamed("/preview-laundry");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile = _profile.profile;
    user = _user.userLoginData;
    _laundries = _profile.getLaundries();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          //title: _breadCrumbs,
          //elevation: 0,
          backgroundColor: kNavyBlue,
          leading: const SizedBox(),
          leadingWidth: 0.0,
          title: Text(
            "Laundrynaa",
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
              ListTile(
                onTap: () => Get.toNamed("/customer-orders"),
                isThreeLine: true,
                leading: const Icon(
                  MaterialCommunityIcons.receipt,
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
                  "View Laundry Orders",
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
          future: _laundries,
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
                    onTap: () => onNavigateToPreviewLaundry(
                      snapshot.data[index],
                    ),
                    contentPadding: EdgeInsets.only(
                      top: index == 0 ? 30.0 : 0,
                      left: 30.0,
                      right: 30.0,
                    ),
                    leading: Hero(
                      tag: snapshot.data[index]["accountId"],
                      child: Image.network(
                        snapshot.data[index]["img"]["avatar"],
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    title: Text(
                      snapshot.data[index]["firstName"],
                      style: GoogleFonts.chivo(
                        color: kCharcoal,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data[index]["address"]["name"],
                      style: GoogleFonts.roboto(
                        color: kCharcoal,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
