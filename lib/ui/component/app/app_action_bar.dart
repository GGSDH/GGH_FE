import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class AppActionBar extends StatelessWidget {
  final String? title;
  final String? rightText;
  final VoidCallback onBackPressed;
  final List<ActionBarMenuItem>? menuItems;

  const AppActionBar(
      {super.key,
      this.title,
      this.rightText,
      required this.onBackPressed,
      this.menuItems});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: title != null
                    ? Text(
                        title!,
                        style: TextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.gray900),
                        overflow: TextOverflow.ellipsis,
                      )
                    : const SizedBox(),
              ),
            ),
            Row(
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
                      padding: EdgeInsets.zero),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (rightText != null && rightText!.isNotEmpty)
                      Text(
                        rightText!,
                        style: TextStyles.bodyLarge
                            .copyWith(color: ColorStyles.gray400),
                      ),
                    if (menuItems != null)
                      ...menuItems!.map(
                        (item) => Container(
                          padding: const EdgeInsets.only(left: 10),
                          width: 34,
                          child: IconButton(
                              icon: item.icon,
                              onPressed: item.onPressed,
                              padding: EdgeInsets.zero),
                        ),
                      ),
                  ],
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
