import 'package:flutter/material.dart';

class ProdutoAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;

  ProdutoAdicionarControllers() {
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
  }
}
