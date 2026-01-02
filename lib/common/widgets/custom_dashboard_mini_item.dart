import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';

class CustomDashboardMiniItem extends StatelessWidget {
  const CustomDashboardMiniItem({
    super.key,
    required this.label,
    required this.value,
    this.width,
  });

  final String label;
  final String value;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 12),
      child: Container(
        height: 120,
        width: width ?? 200,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x1F000000),
              offset: Offset(0.0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F4F8),
                  shape: BoxShape.circle,
                ),
                alignment: const AlignmentDirectional(0, 0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: kColorStylePrimaryNeutralPaletteDarkDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.group_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF57636C),
                        fontSize: 14,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF14181B),
                          fontSize: 36,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Custom Dashboard Mini Item')
Widget customDashboardMiniItemPreview() {
  return CustomDashboardMiniItem(label: 'Total Users', value: '1,234');
}
