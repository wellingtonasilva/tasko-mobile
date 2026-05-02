import 'package:flutter/material.dart';

class CustomActionIconButton extends StatelessWidget {
  final Icon icon;
  final Function()? onPressed;
  final Color color;
  final Color? borderColor;

  const CustomActionIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(Size(10, 10)),
        minimumSize: WidgetStateProperty.all(Size(35, 30)),
        padding: WidgetStateProperty.all(EdgeInsets.all(2)),
        backgroundColor: WidgetStateProperty.all(color),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Bordas arredondadas
            side: BorderSide(color: borderColor ?? color, width: 1), // B
          ),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
