import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  static StateController get i => Get.find();
  final searching = false.obs;

  setSearching(bool flag) {
    searching(flag);
  }
}
