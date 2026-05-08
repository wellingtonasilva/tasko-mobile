import 'package:flutter/material.dart';

class Configuracao {
  final String label;
  final String? value;
  final IconData? prefixIcon;
  final bool showArrow;

  Configuracao({
    required this.label,
    this.value,
    this.prefixIcon,
    this.showArrow = true,
  });
}
