import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app_action_bar.dart';

class StationDetailScreen extends StatefulWidget {
  static const images = [
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/300"
  ];

  const StationDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StationDetailScreenState();
  }
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SafeArea(
            child: Column(
          children: [
            AppActionBar(rightText: "", onBackPressed: () => {}, menuItems: [
              ActionBarMenuItem(
                  icon: SvgPicture.asset(
                    "assets/icons/ic_map.svg",
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () => print("map clicked")),
              ActionBarMenuItem(
                  icon: SvgPicture.asset(
                    "assets/icons/ic_heart.svg",
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () => print("like clicked")),
            ]),
            SizedBox(
              height: 295,
              child: Stack(
                children: [
                  PageView.builder(
                      onPageChanged: (value) => {
                            setState(() {
                              _currentPage = value;
                            })
                          },
                      itemCount: StationDetailScreen.images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          StationDetailScreen.images[index],
                          fit: BoxFit.cover,
                          height: 295,
                          width: double.infinity,
                        );
                      }),
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "${_currentPage + 1}/${StationDetailScreen.images.length}",
                        style: TextStyles.titleXSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.grayWhite),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
