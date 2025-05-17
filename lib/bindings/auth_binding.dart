import 'package:get/get.dart';
import 'package:cost_control/controllers/auth_controller.dart';
import 'package:cost_control/repositories/user_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserRepository(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}