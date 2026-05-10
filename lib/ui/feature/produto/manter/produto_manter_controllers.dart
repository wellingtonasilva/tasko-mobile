import 'package:flutter/material.dart';

class ProdutoManterControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;

  ProdutoManterControllers() {
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
  }
}
