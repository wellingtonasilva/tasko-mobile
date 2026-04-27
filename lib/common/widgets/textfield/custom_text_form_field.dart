import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final Iterable<String>? autofillHints;
  final Widget? prefixIcon;
  final Color? fillColor;
  final String? hintText;
  final String? Function(BuildContext, String?)? validator;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.autofillHints,
    this.prefixIcon,
    this.fillColor,
    this.hintText,
    this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool passwordVisibility;

  bool get _isPassword =>
      widget.autofillHints!.contains(AutofillHints.password);

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      obscureText: !_isPassword ? false : !passwordVisibility,
      autofillHints: widget.autofillHints,
      validator: widget.validator != null
          ? (value) => widget.validator!(context, value)
          : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: kTestStyleMediumText16.copyWith(
          color: kColorStyleSecondinaryDarkDefault,
        ),
        hintText: widget.hintText,
        hintStyle: widget.hintText == null
            ? null
            : kTestStyleMediumText12.copyWith(
                color: kColorStyleSecondinaryLight300,
              ),
        floatingLabelStyle: kTestStyleMediumText14.copyWith(
          color: kColorStyleSecondinaryLight300,
        ),
        errorStyle: kTestStyleMediumText12,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kColorStyleSecondinaryLight200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kColorStyleSecondinaryLight200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kColorStyleErrorLight300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kColorStyleErrorLight300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: widget.fillColor != null ? true : false,
        fillColor: widget.fillColor,
        contentPadding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
        prefixIcon: widget.prefixIcon,
        suffixIcon: !_isPassword
            ? null
            : InkWell(
                onTap: () =>
                    setState(() => passwordVisibility = !passwordVisibility),
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  passwordVisibility
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: passwordVisibility
                      ? kColorStyleSecondinaryLight300
                      : kColorStyleSecondinaryLightDefault,
                  size: 24.0,
                ),
              ),
      ),
      cursorColor: kColorStylePrimaryNeutralPaletteDark900,
    );
  }
}
