import '../../model/user_master.dart';

abstract class ILoginController {
  Future<UserMaster?> login({
    required String emailId,
    required String password,
  });

  Future<String> register({
    required UserMaster entity,
  });
}
