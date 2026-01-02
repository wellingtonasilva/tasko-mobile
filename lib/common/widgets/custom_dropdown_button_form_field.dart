import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final String hint;
  final List<T> items;
  final String Function(T) itemLabelBuilder; // Function to extract item label
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final T? selectedValue;

  const CustomDropdownButtonFormField({
    super.key,
    required this.hint,
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
      hint: Text(
        hint,
        style: const TextStyle(
          fontFamily: 'Outfit',
          color: Color(0xFF606A85),
          fontSize: 16,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabelBuilder(item),
                style: const TextStyle(
                  color: Color(0xFF15161E),
                  fontSize: 16,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
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
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
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
