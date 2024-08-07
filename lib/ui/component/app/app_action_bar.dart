import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class AppActionBar extends StatelessWidget {
  final String rightText;
  final VoidCallback onBackPressed;

  final List<ActionBarMenuItem> menuItems;

  const AppActionBar({
    super.key,
    required this.rightText,
    required this.onBackPressed,
    required this.menuItems
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 24,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/ic_arrow_back.svg",
                  width: 24,
                  height: 24,
                ),
                onPressed: onBackPressed,
                padding: EdgeInsets.zero
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    rightText,
                    style: TextStyles.bodyLarge
                        .copyWith(color: ColorStyles.gray400),
                  ),
                ),
                ...menuItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 24,
                      child: IconButton(
                        icon: item.icon,
                        onPressed: item.onPressed,
                        padding: EdgeInsets.zero
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionBarMenuItem {
  final VoidCallback onPressed;
  final Widget icon;

  const ActionBarMenuItem({required this.icon, required this.onPressed});
}
