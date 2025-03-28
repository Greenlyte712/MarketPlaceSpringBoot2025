import 'package:find_a_pro_pronto_app/pages/buyer_dashboard_page.dart';
import 'package:find_a_pro_pronto_app/pages/create_buyer_page.dart';
import 'package:find_a_pro_pronto_app/pages/create_seller_page.dart';
import 'package:find_a_pro_pronto_app/pages/login_page.dart';
import 'package:find_a_pro_pronto_app/pages/rest_password_email_page.dart';
import 'package:find_a_pro_pronto_app/pages/seller_dashboard_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:find_a_pro_pronto_app/pages/reset_password_form_page.dart';
import 'package:find_a_pro_pronto_app/pages/home_page.dart';
import 'package:find_a_pro_pronto_app/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? initialLink;

  // GlobalKey for NavigatorState
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initDeepLink();
  }

  Future<void> initDeepLink() async {
    if (kIsWeb) {
      initialLink = Uri.base.toString();
      if (initialLink != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          handleDeepLink(initialLink!);
        });
      }
    }
  }

  void handleDeepLink(String url) {
    Uri uri = Uri.parse(url);
    print("Deep link: $url");

    if (uri.path == "/frontendRequestResetPassword" &&
        uri.queryParameters.containsKey("token")) {
      String token = uri.queryParameters["token"]!;

      // Use the GlobalKey Navigator to navigate
      navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => ResetPasswordFormPage(token: token)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey, // Set the navigatorKey for MaterialApp
      initialRoute: '/',
      onGenerateRoute: (settings) {
        print("Received route: ${settings.name}");
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => HomePage());
        } else if (settings.name == '/create-seller') {
          return MaterialPageRoute(builder: (context) => CreateSellerPage());
        } else if (settings.name == '/create-buyer') {
          return MaterialPageRoute(builder: (context) => CreateBuyerPage());
        } else if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => LoginPage());
        } else if (settings.name == '/reset-password') {
          return MaterialPageRoute(
              builder: (context) => ResetPasswordEmailPage());
        } else if (settings.name == '/seller-dashboard') {
          return MaterialPageRoute(builder: (context) => SellerDashboardPage());
        } else if (settings.name == '/buyer-dashboard') {
          return MaterialPageRoute(builder: (context) => BuyerDashboardPage());
        }
        return null; // Return null for unhandled routes
      },
    );
  }
}
