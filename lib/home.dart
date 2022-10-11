import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_sum/controllers/state_controller.dart';

class Home extends GetView<StateController> {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Container());
  }
}
