import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final String? hint;
  final List<T> items;
  final String Function(T) itemLabelBuilder; // Function to extract item label
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final T? selectedValue;

  const CustomDropdownButtonFormField({
    super.key,
    this.hint,
    required this.items,
    required this.itemLabelBuilder,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: kColorStylePrimary0,
        filled: true,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(5, 20, 16, 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      hint: hint != null
          ? Text(
              hint!,
              style: kTestStyleMediumText16.copyWith(
                color: kColorStyleSecondinaryLight300,
              ),
            )
          : null,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabelBuilder(item),
                style: kTestStyleMediumText16.copyWith(
                  color: kColorStyleSecondinaryDarkDefault,
                ),
              ),
            ),
          )
          .toList(),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      value: selectedValue,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: IconStyleData(
        icon: Image.asset(
          'assets/images/pos_icon_arrow_down.png',
          width: 24,
          height: 24,
          color: kColorStyleSecondinaryDarkDefault,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
