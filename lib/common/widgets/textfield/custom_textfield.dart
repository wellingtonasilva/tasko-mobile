import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomTextfield extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final bool disabled;
  final String? Function(BuildContext, String?)? validator;

  const CustomTextfield({
    super.key,
    this.labelText,
    this.controller,
    this.disabled = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        autofocus: true,
        autofillHints: const [AutofillHints.email],
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: kTestStyleMediumText16.copyWith(
            color: kColorStyleSecondinaryLight300,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE0E3E7), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kColorStyleSecondinaryLight200,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF5963), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF5963), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: disabled
              ? kColorStyleSecondinaryLight200
              : kColorStylePrimary0,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(18, 18, 0, 18),
        ),
        style: kTestStyleMediumText16.copyWith(
          color: disabled
              ? kColorStyleSecondinaryLight400
              : kColorStyleSecondinaryDarkDefault,
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            validator != null ? validator!(context, value) : null,
      ),
    );
  }
}

@Preview(name: 'Custom TextField Preview')
Widget customListItemPreview() {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CustomTextfield(labelText: 'Email'),
  );
}
