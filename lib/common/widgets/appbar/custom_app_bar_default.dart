import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_icon_button.dart';

class CustomAppBarDefault extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onSettingsPressed;

  const CustomAppBarDefault({
    super.key,
    this.onMenuPressed,
    this.onSearchPressed,
    this.onSettingsPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 8.0,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onSearchPressed,
            icon: Image.asset(
              'assets/images/pos_icon_search_normal.png',
              color: kColorStyleSecondinaryDarkDefault,
              width: 24,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              overlayColor: WidgetStateProperty.all<Color>(
                Colors.grey.shade200,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: kColorStyleSecondinaryLight200,
                    width: 1,
                  ),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(const Size(22, 22)),
            ),
          ),
          IconButton(
            onPressed: onSettingsPressed,
            icon: Image.asset(
              'assets/images/pos_icon_setting.png',
              color: kColorStyleSecondinaryDarkDefault,
              width: 24,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              overlayColor: WidgetStateProperty.all<Color>(
                Colors.grey.shade200,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: kColorStyleSecondinaryLight200,
                    width: 1,
                  ),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(const Size(22, 22)),
            ),
          ),
        ],
      ),
      backgroundColor: kColorStylePrimaryNeutralPaletteLightDefault,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomIconButton(
          icon: const Icon(
            Icons.menu,
            color: kColorStyleSecondinaryDarkDefault,
            size: 24,
          ),
          borderRadius: 12,
          buttonSize: 25,
          fillColor: Colors.white,
          hoverColor: Colors.grey.shade200,
          borderColor: kColorStyleSecondinaryLight200,
          borderWidth: 1,
          showLoadingIndicator: false,
          onPressed: () => onMenuPressed?.call(),
        ),
      ),
    );
  }
}
