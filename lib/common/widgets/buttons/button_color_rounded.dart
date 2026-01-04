import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class ButtonColorRounded extends StatelessWidget {
  const ButtonColorRounded({
    super.key,
    required this.text,
    this.height,
    this.width,
    this.onPressed,
    this.color,
  });

  final String text;
  final double? height;
  final double? width;
  final Function()? onPressed;
  final Color? color;

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
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: 0.5,
                color: color ?? const Color(0xFF4B39EF),
              ),
            );
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return color ?? const Color(0xFF4B39EF);
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return color ?? const Color(0xFF4B39EF);
          }),
          elevation: WidgetStateProperty.resolveWith<double?>((states) {
            return 0.5;
          }),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Button Color Rounded')
Widget buttonColorRoundedPreview() {
  return ButtonColorRounded(
    text: 'Button',
    height: 48,
    width: 200,
    onPressed: () {},
  );
}
