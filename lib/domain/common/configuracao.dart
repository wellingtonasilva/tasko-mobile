import 'package:flutter/material.dart';

class Configuracao {
  final String key;
  final String label;
  final String? value;
  final IconData? prefixIcon;
  final bool showArrow;

  Configuracao({
    required this.key,
    required this.label,
    this.value,
    this.prefixIcon,
    this.showArrow = true,
  });
}
