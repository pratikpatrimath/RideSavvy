import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'utility/constants/string_constants.dart';
import 'utility/routes/route_constants.dart';
import 'utility/routes/route_screens.dart';
import 'utility/services/user_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  await Stripe.instance.applySettings();
  String userId = (await UserPref.getUserId()).toString();
  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    bool isUserIdEmpty = userId == "-1" || userId == "0" || userId.isEmpty;

    return GetMaterialApp(
      title: StringConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: isUserIdEmpty
          ? RouteConstants.loginScreen
          : RouteConstants.homeScreen,
      getPages: RouteScreens.routes,
    );
  }
}
