import 'package:app/const/color.dart';
import 'package:app/screens/account/login.dart';
import 'package:app/screens/account/register/register_1.dart';
import 'package:app/screens/account/register/register_2.dart';
import 'package:app/screens/account/register/register_3.dart';
import 'package:app/screens/account/register/register_4.dart';
import 'package:app/screens/customer/main_customer.dart';
import 'package:app/screens/customer/preview/preview_laundry.dart';
import 'package:app/screens/customer/sub_screens/history.dart';
import 'package:app/screens/customer/sub_screens/orders.dart';
import 'package:app/screens/customer/sub_screens/profile.dart';
import 'package:app/screens/laundry/main_laundry.dart';
import 'package:app/screens/laundry/preview/preview_order_inprogress.dart';
import 'package:app/screens/laundry/preview/preview_order_pending.dart';
import 'package:app/screens/laundry/preview/preview_order_ready.dart';
import 'package:app/screens/laundry/sub_screens/history.dart';
import 'package:app/screens/laundry/sub_screens/manage.dart';
import 'package:app/screens/laundry/sub_screens/manage_create_listing.dart';
import 'package:app/screens/laundry/sub_screens/orders.dart';
import 'package:app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/customer/preview/preview_order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Laundrynaa',
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(kBlueGrotto),
        ),
        backgroundColor: Colors.white,
        primarySwatch: Colors.grey,
      ),
      //defaultTransition: Transition.zoom,
      home: const Login(),
      getPages: [
        GetPage(name: "/loading", page: () => const Loading()),
        GetPage(name: "/login", page: () => const Login()),
        GetPage(name: "/register", page: () => const Register()),
        GetPage(name: "/register-2", page: () => const RegisterStep2()),
        GetPage(name: "/register-3", page: () => const RegisterStep3()),
        GetPage(name: "/register-4", page: () => const RegisterStep4()),

        // CUSTOMER
        GetPage(
          name: "/customer",
          page: () => const Customer(),
        ),
        GetPage(
          name: "/customer-profile",
          page: () => const CustomerProfile(),
        ),
        GetPage(
          name: "/customer-orders",
          page: () => const CustomerOrders(),
        ),
        GetPage(
          name: "/customer-orders-history",
          page: () => const CustomerOrderHistory(),
        ),

        // LAUNDRY
        GetPage(
          name: "/laundry",
          page: () => const Laundry(),
        ),
        GetPage(
          name: "/laundry-manage",
          page: () => const Manage(),
        ),
        GetPage(
          name: "/laundry-manage-create-listing",
          page: () => const ManageCreateListing(),
        ),

        GetPage(
          name: "/laundry-orders",
          page: () => const LaundryOrders(),
        ),
        GetPage(
          name: "/laundry-orders-history",
          page: () => const LaundryOrderHistory(),
        ),

        // PREVIEW
        GetPage(
          name: "/preview-laundry",
          page: () => const PreviewLaundry(),
        ),
        // PREVIEW
        GetPage(
          name: "/preview-customer-order-pending",
          page: () => const PreviewCustomerPendingOrder(),
        ),
        GetPage(
          name: "/preview-customer-order-inprogress",
          page: () => const PreviewCustomerInprogressOder(),
        ),
        GetPage(
          name: "/preview-customer-order-ready",
          page: () => const PreviewCustomerReadyOrder(),
        ),

        GetPage(
          name: "/preview-customer-order",
          page: () => const PreviewCustomerOrder(),
        ),
      ],
    );
  }
}
