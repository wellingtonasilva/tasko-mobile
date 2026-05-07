import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_edit_icon_button.dart';

class CustomReviewContainer extends StatelessWidget {
  final String label;
  final VoidCallback? onEdit;
  final List<Widget> children;

  const CustomReviewContainer({
    super.key,
    required this.label,
    this.onEdit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 2, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: kTestStyleBoldText16)),
              if (onEdit != null) CustomActionEditIconButton(onPressed: onEdit),
            ],
          ),
          SizedBox(height: 5),
          ...children,
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
