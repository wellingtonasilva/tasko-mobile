import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

class CustomFormFieldData {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String? Function(BuildContext, String?)? validator;

  CustomFormFieldData({
    required this.controller,
    required this.focusNode,
    required this.labelText,
    this.validator,
  });
}

@Preview(name: 'Custom Form Field Data Example')
Widget customFormFieldDataPreview() {
  final formFieldData = CustomFormFieldData(
    controller: TextEditingController(),
    focusNode: FocusNode(),
    labelText: 'Example Label',
    validator: (context, value) {
      if (value == null || value.isEmpty) {
        return 'This field cannot be empty';
      }
      return null;
    },
  );
  return Text(formFieldData.labelText);
}
