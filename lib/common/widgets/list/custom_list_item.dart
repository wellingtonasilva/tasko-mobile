import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomListItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? subtitle1;
  final String? subtitle2;
  final Function()? onTap;

  const CustomListItem({
    super.key,
    this.title,
    this.subtitle,
    this.subtitle1,
    this.subtitle2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InkWell(
        child: Container(
          width: 468.9,
          //height: 72,
          decoration: BoxDecoration(
            color: kColorStylePrimaryNeutralPaletteLightDefault,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: kColorStyleSecondinaryLight300,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 5, 0, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            title ?? '',
                            style: kTestStyleRegularText16,
                          ),
                        ),
                        Text(subtitle ?? '', style: kTestStyleRegularText14),
                        if (subtitle1 != null)
                          Text(subtitle1!, style: kTestStyleRegularText14),
                        if (subtitle2 != null)
                          Text(subtitle2!, style: kTestStyleRegularText14),
                      ],
                    ),
                  ),
                ),
                onTap != null
                    ? Icon(
                        Icons.chevron_right_rounded,
                        color: kColorStyleSecondinaryDark600,
                        size: 24,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Custom List Item')
Widget customListItemPreview() {
  return CustomListItem(
    title: 'List Item Title',
    subtitle: 'This is a subtitle for the list item.',
    subtitle1: 'Additional info line 1',
    subtitle2: 'Additional info line 2',
    onTap: () {
      // Handle tap event
    },
  );
}
