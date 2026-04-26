import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButtonOptions {
  const CustomButtonOptions({
    this.textAlign,
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
    this.hoverColor,
    this.hoverBorderSide,
    this.hoverTextColor,
    this.hoverElevation,
    this.maxLines,
  });

  /// The alignment of the button's text within its bounds.
  final TextAlign? textAlign;

  /// The style of the button's text.
  final TextStyle? textStyle;

  /// The elevation of the button.
  final double? elevation;

  /// The height of the button.
  final double? height;

  /// The width of the button.
  final double? width;

  /// The padding around the button's content.
  final EdgeInsetsGeometry? padding;

  /// The background color of the button.
  final Color? color;

  /// The background color of the button when it is disabled.
  final Color? disabledColor;

  /// The text color of the button when it is disabled.
  final Color? disabledTextColor;

  /// The maximum number of lines for the button's text.
  final int? maxLines;

  /// The color of the splash effect when the button is pressed.
  final Color? splashColor;

  /// The size of the button's icon.
  final double? iconSize;

  /// The color of the button's icon.
  final Color? iconColor;

  /// The padding around the button's icon.
  final EdgeInsetsGeometry? iconPadding;

  /// The border radius of the button.
  final BorderRadius? borderRadius;

  /// The border of the button.
  final BorderSide? borderSide;

  /// The background color of the button when it is hovered.
  final Color? hoverColor;

  /// The border of the button when it is hovered.
  final BorderSide? hoverBorderSide;

  /// The text color of the button when it is hovered.
  final Color? hoverTextColor;

  /// The elevation of the button when it is hovered.
  final double? hoverElevation;
}

class CustomButton extends StatelessWidget {
  final String? label;
  final CustomButtonOptions options;
  final Function()? onPressed;
  final Widget? icon;
  final IconData? iconData;
  final Image? iconImage;

  const CustomButton({
    super.key,
    this.label,
    required this.options,
    this.onPressed,
    this.icon,
    this.iconData,
    this.iconImage,
  });

  int get maxLines => options.maxLines ?? 1;

  String? get text => options.textStyle?.fontSize == 0 ? null : label;

  @override
  Widget build(BuildContext context) {
    bool loading = false;

    Widget textWidget = loading
        ? SizedBox(
            width: options.width == null
                ? _getTextWidth(text, options.textStyle, maxLines)
                : null,
            child: Center(
              child: SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    options.textStyle?.color ?? Colors.white,
                  ),
                ),
              ),
            ),
          )
        : AutoSizeText(
            text ?? '',
            style: text == null ? null : options.textStyle?.withoutColor(),
            textAlign: options.textAlign,
            maxLines: options.maxLines,
            overflow: TextOverflow.ellipsis,
          );

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(WidgetState.hovered) &&
            options.hoverBorderSide != null) {
          return RoundedRectangleBorder(
            borderRadius: options.borderRadius ?? BorderRadius.circular(8),
            side: options.hoverBorderSide!,
          );
        }
        return RoundedRectangleBorder(
          borderRadius: options.borderRadius ?? BorderRadius.circular(8),
          side: options.borderSide ?? BorderSide.none,
        );
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled) &&
            options.disabledTextColor != null) {
          return options.disabledTextColor;
        }
        if (states.contains(WidgetState.hovered) &&
            options.hoverTextColor != null) {
          return options.hoverTextColor;
        }
        return options.textStyle?.color ?? Colors.white;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled) &&
            options.disabledColor != null) {
          return options.disabledColor;
        }
        if (states.contains(WidgetState.hovered) &&
            options.hoverColor != null) {
          return options.hoverColor;
        }
        return options.color;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return options.splashColor;
        }
        return options.hoverColor == null ? null : Colors.transparent;
      }),
      padding: WidgetStateProperty.all(
        options.padding ??
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      ),
      elevation: WidgetStateProperty.resolveWith<double?>((states) {
        if (states.contains(WidgetState.hovered) &&
            options.hoverElevation != null) {
          return options.hoverElevation!;
        }
        return options.elevation ?? 0.0;
      }),
    );

    if ((icon != null || iconData != null || iconImage != null) && !loading) {
      Widget? defaultIcon;

      if (iconImage == null) {
        defaultIcon =
            icon ??
            FaIcon(iconData!, size: options.iconSize, color: options.iconColor);
      }

      if (text == null) {
        return Container(
          height: options.height,
          width: options.width,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              options.borderSide ?? BorderSide.none,
            ),
            borderRadius: options.borderRadius ?? BorderRadius.circular(8),
          ),
          child: IconButton(
            splashRadius: 1.0,
            icon: Padding(
              padding: options.iconPadding ?? EdgeInsets.zero,
              child: defaultIcon,
            ),
            onPressed: onPressed,
            style: style,
          ),
        );
      }
      return SizedBox(
        height: options.height,
        width: options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: options.iconPadding ?? EdgeInsets.zero,
            child: iconImage ?? defaultIcon,
          ),
          label: textWidget,
          onPressed: onPressed,
          style: style,
        ),
      );
    }

    return SizedBox(
      height: options.height,
      width: options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: textWidget,
      ),
    );
  }
}

extension _WithoutColorExtension on TextStyle {
  /// Returns a new [TextStyle] object without the color property.
  TextStyle withoutColor() => TextStyle(
    inherit: inherit,
    color: null,
    backgroundColor: backgroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    height: height,
    leadingDistribution: leadingDistribution,
    locale: locale,
    foreground: foreground,
    background: background,
    shadows: shadows,
    fontFeatures: fontFeatures,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
    debugLabel: debugLabel,
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    overflow: overflow,
  );
}

double? _getTextWidth(String? text, TextStyle? style, int maxLines) =>
    text != null
    ? (TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
      )..layout()).size.width
    : null;
