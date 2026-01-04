import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.borderRadius,
    this.buttonSize,
    this.fillColor,
    this.disabledColor,
    this.disabledIconColor,
    this.hoverColor,
    this.hoverIconColor,
    this.borderColor,
    this.borderWidth,
    required this.showLoadingIndicator,
    required this.onPressed,
  });

  final Widget icon;
  final double? borderRadius;
  final double? buttonSize;
  final Color? fillColor;
  final Color? disabledColor;
  final Color? disabledIconColor;
  final Color? hoverColor;
  final Color? hoverIconColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showLoadingIndicator;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    late double? iconSize;
    late Color? iconColor;

    Icon icone = icon as Icon;
    iconSize = icone.size;
    iconColor = icone.color;

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        );
      }),
      iconColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled) &&
            disabledIconColor != null) {
          return disabledIconColor;
        }
        if (states.contains(WidgetState.hovered) && hoverIconColor != null) {
          return hoverIconColor;
        }
        return iconColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled) && disabledColor != null) {
          return disabledColor;
        }
        if (states.contains(WidgetState.hovered) && hoverColor != null) {
          return hoverColor;
        }

        return fillColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return null;
        }
        return hoverColor == null ? null : Colors.transparent;
      }),
    );

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Theme(
        data: ThemeData.from(
          colorScheme: Theme.of(context).colorScheme,
          useMaterial3: true,
        ),
        child: IconButton(
          icon: icone,
          onPressed: onPressed,
          splashRadius: buttonSize,
          style: style,
        ),
      ),
    );
  }
}

@Preview(name: 'Custom Icon Button')
Widget customIconButtonPreview() {
  return CustomIconButton(
    icon: const Icon(Icons.favorite, color: Colors.red, size: 24),
    borderRadius: 12,
    buttonSize: 48,
    fillColor: Colors.white,
    hoverColor: Colors.grey.shade200,
    borderColor: Colors.red,
    borderWidth: 2,
    showLoadingIndicator: false,
    onPressed: () {},
  );
}
