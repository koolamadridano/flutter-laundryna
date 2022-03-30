import 'package:app/const/color.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/helpers/destroy_inputFocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Manage extends StatefulWidget {
  const Manage({Key? key}) : super(key: key);

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  String _toDeleteId = "";
  final _listing = Get.put(ListingController());

  late Future<dynamic> _listings;

  Future<void> onDelete(id) async {
    setState(() {
      _toDeleteId = id;
    });
    await _listing.deleteListing(id);
    refresh();
  }

  Future<void> refresh() async {
    setState(() {
      _listings = _listing.getListings(availability: true);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listings = _listing.getListings(availability: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
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
            "Preferences",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed("/laundry-manage-create-listing"),
              splashRadius: 20.0,
              icon: const Icon(
                AntDesign.plus,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: _listings,
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
                    contentPadding: EdgeInsets.only(
                      top: index == 0 ? 30.0 : 0,
                      left: 30.0,
                      right: 30.0,
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
                            onTap: () => onDelete(snapshot.data[index]["_id"]),
                            child: const Icon(
                              FontAwesome.trash,
                              color: Colors.red,
                            ),
                          ),
                    title: Text(
                      snapshot.data[index]["title"],
                      style: GoogleFonts.chivo(
                        color: kCharcoal,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
                      ),
                    ),
                    subtitle: Text(
                      "P${snapshot.data[index]["price"]}",
                      style: GoogleFonts.robotoMono(
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
