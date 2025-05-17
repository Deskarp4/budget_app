  import 'package:get/get.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import '../repositories/user_repository.dart';
  import '../models/user_model.dart';
  import '../repositories/tx_repository.dart';
  import '../controllers/tx_controller.dart';
  import 'package:cost_control/controllers/budget_controller.dart';

  class AuthController extends GetxController {
    static AuthController get instance => Get.find();

    final _auth     = FirebaseAuth.instance;
    final _userRepo = UserRepository.instance;

    /* ─────────── регистрация ─────────── */
    Future<void> register(String email, String password, String username) async {
      try {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final uid = cred.user!.uid;
        Get.put(TxRepository(uid));
        Get.put(TxController());
        Get.put(BudgetController(), permanent: true);

        await _userRepo.createUser(UserModel(
          id:      uid,
          email:   email,
          username: username,
          password: password,
        ));
        Get.offAllNamed('/home');
      } on FirebaseAuthException catch (e) {
        _showError(e.message);
      }
    }

    /* ─────────── логин ─────────── */
    Future<void> login(String email, String password) async {
      try {
        final cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        final uid = cred.user!.uid;

        _registerDeps(uid);

        Get.put(TxRepository(uid));
        Get.put(TxController());
        Get.put(BudgetController(), permanent: true);

        Get.offAllNamed('/home');
      } on FirebaseAuthException catch (e) {
        _showError(e.message);
      }
    }


    /* ─────────── выход ─────────── */
    Future<void> logout() async {
      await _auth.signOut();
      Get.delete<TxController>();
      Get.delete<TxRepository>();
      Get.delete<BudgetController>();
      Get.offAllNamed('/login');
    }

    /* ─────────── helper ─────────── */
    void _showError(String? msg) => Get.snackbar(
      'Error',
      msg ?? 'Authentication failed',
      backgroundColor: Colors.red.withOpacity(0.1),
      snackPosition: SnackPosition.BOTTOM,
    );

    void _registerDeps(String uid) {
      debugPrint('AuthController REGISTER DEPS  →  uid=$uid');

      Get.delete<TxRepository>(force: true);
      Get.delete<TxController>(force: true);
      Get.delete<BudgetController>(force: true);
    }
  }
