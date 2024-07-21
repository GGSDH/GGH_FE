import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          _buildCategories()
        ],
      )
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 44, 0, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical : 15
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_app_title.svg',
              width: 57,
              height: 24
            ),
            Row(
              children: [
                _buildIconButton(
                  "assets/icons/ic_heart_white.svg",
                  () {
                    // Handle heart icon tap
                  },
                ),
                const SizedBox(width: 14),
                _buildIconButton(
                  "assets/icons/ic_search_white.svg",
                  () {
                    // Handle search icon tap
                  },
                ),
              ],
            )
          ]
        )
      ),
    );
  }

  Widget _buildBanner() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 394,
          color: ColorStyles.gray800,
        ),

        Container(
          width : double.infinity,
          height: 394,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(1.0),
              ]
            ),
          ),
        ),

        const SizedBox(height: 133),

        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 35),
              const Text(
                "나만의 노선으로\n떠나는 여행",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "지금 떠나보세요!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        ),

        Positioned(
          right: 0,
          top: 152,
          child: SvgPicture.asset(
            "assets/icons/ic_home_illust.svg",
            width : 205,
            height: 166
          ),
        )
      ]
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onTap, {double width = 24, double height = 24}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      '체험', '핫플', '관광', '지역특색', '문화', '맛집', '힐링'
    ];

    return SizedBox(
      height: 108,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(20),
        children: [
          for (final category in categories) ...[
            _buildCategoryItem(
                "assets/icons/ic_category.svg",
                category,
                    () {

                }
            ),
            const SizedBox(width: 8)
          ]
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String assetPath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: ColorStyles.gray800,
              fontSize: 14,
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecommendBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "전예나",
                  style: TextStyles.titleExtraLarge
                )
              ),
              GestureDetector(
                onTap: () {
                  // Handle more tap
                },
                child: const Text(
                  "더보기",
                  style: TextStyle(
                    color: ColorStyles.gray500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}