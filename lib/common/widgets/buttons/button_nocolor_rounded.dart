import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class ButtonNoColorRounded extends StatelessWidget {
  const ButtonNoColorRounded({
    super.key,
    required this.text,
    this.height,
    this.width,
    this.onPressed,
  });

  final String text;
  final double? height;
  final double? width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: const BorderSide(width: 1, color: Colors.black),
            );
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return Colors.white;
          }),
          elevation: WidgetStateProperty.resolveWith<double?>((states) {
            return 1.0;
          }),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Button No Color Rounded')
Widget buttonNoColorRoundedPreview() {
  return ButtonNoColorRounded(
    text: 'Button',
    height: 48,
    width: 200,
    onPressed: () {},
  );
}
