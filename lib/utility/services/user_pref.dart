import 'package:get_storage/get_storage.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class UserPref {
  static final getStorage = GetStorage();

  static Future<void> setUserIdAndName({
    required int? userId,
    required String? name,
  }) async {
    await getStorage.write(StringConstants.userId, userId);
    await getStorage.write(StringConstants.name, name);
  }

  static Future<int> getUserId() async {
    try {
      return await getStorage.read(StringConstants.userId);
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 19");
      return -1;
    }
  }

  static Future<String> getUserName() async {
    try {
      return await getStorage.read(StringConstants.name);
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 30");
      return "";
    }
  }

  static removeAllFromUserPref() async {
    try {
      await GetStorage.init();
      return await getStorage.erase();
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 29");
      return Future.error(e);
    }
  }
}
