import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomTextfield extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final bool disabled;
  final String? Function(BuildContext, String?)? validator;
  final Widget? prefixIcon;
  final bool readOnly;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool showBorder;

  const CustomTextfield({
    super.key,
    this.labelText,
    this.controller,
    this.disabled = false,
    this.validator,
    this.prefixIcon,
    this.readOnly = false,
    this.hintText,
    this.inputFormatters,
    this.keyboardType,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextFormField(
        controller: controller,
        autofocus: true,
        readOnly: readOnly,
        autofillHints: const [AutofillHints.email],
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: kTestStyleMediumText16.copyWith(
            color: kColorStyleSecondinaryLight300,
          ),
          enabledBorder: showBorder
              ? OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E3E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              : InputBorder.none,
          focusedBorder: showBorder
              ? OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: kColorStyleSecondinaryLight200,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              : InputBorder.none,
          errorBorder: showBorder
              ? OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5963),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              : InputBorder.none,
          focusedErrorBorder: showBorder
              ? OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5963),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              : InputBorder.none,
          filled: false,
          fillColor: disabled
              ? kColorStyleSecondinaryLight200
              : kColorStylePrimary0,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: kTestStyleMediumText16.copyWith(
            color: kColorStyleSecondinaryLight300,
          ),
        ),
        style: kTestStyleMediumText16.copyWith(
          color: disabled
              ? kColorStyleSecondinaryLight400
              : kColorStyleSecondinaryDarkDefault,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: (value) =>
            validator != null ? validator!(context, value) : null,
      ),
    );
  }
}
