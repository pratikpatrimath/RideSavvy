import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../screen/change_password_screen.dart';
import '../../screen/driver_details_screen.dart';
import '../../screen/home_screen.dart';
import '../../screen/login_screen.dart';
import '../../screen/profile_screen.dart';
import '../../screen/registration_screen.dart';
import '../../screen/view_all_vehicle_prices_screen.dart';
import 'route_constants.dart';

class RouteScreens {
  static final routes = [
    GetPage(
      name: RouteConstants.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: RouteConstants.registrationScreen,
      page: () => RegistrationScreen(),
    ),
    GetPage(
      name: RouteConstants.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteConstants.profileScreen,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: RouteConstants.changePasswordScreen,
      page: () => ChangePasswordScreen(),
    ),
    GetPage(
      name: RouteConstants.viewAllVehiclePricesScreen,
      page: () => ViewAllVehiclePricesScreen(),
    ),
    GetPage(
      name: RouteConstants.driverDetailsScreen,
      page: () => DriverDetailsScreen(),
    ),
  ];
}
