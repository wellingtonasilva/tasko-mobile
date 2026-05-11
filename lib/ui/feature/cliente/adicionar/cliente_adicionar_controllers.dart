import 'package:flutter/material.dart';

class ClienteAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;

  ClienteAdicionarControllers() {
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
  }
}
