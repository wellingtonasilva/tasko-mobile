import 'package:flutter/material.dart';

class VendedorMetasControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;

  VendedorMetasControllers() {
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
  }
}
