import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  final hide = false.obs;

  setNav(bool flag) {
    hide(flag);
    update();
  }
}
