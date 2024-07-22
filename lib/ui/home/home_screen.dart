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
          _buildCategories(),
          _buildRecommendBody(),
          _buildRestaurantBody(),
          _buildPopularPlaceBody()
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
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20
        ),
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
          SizedBox(
            width: 60,
            child: Text(
              title,
              style: const TextStyle(
                color: ColorStyles.gray800,
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecommendBody() {
    final recommendations = [
      {
        'category': '힐링',
        'title': '이게낭만이지선',
        'description': '낭만 가득한 힐링 맛집 가득 여행',
        'period': '4박 5일',
        'likeCount': 3,
        'isLiked': true
      },
      {
        'category': '힐링',
        'title': '이게낭만이지선',
        'description': '낭만 가득한 힐링 맛집 가득 여행',
        'period': '4박 5일',
        'likeCount': 3,
        'isLiked': false
      },
      {
        'category': '힐링',
        'title': '이게낭만이지선',
        'description': '낭만 가득한 힐링 맛집 가득 여행',
        'period': '4박 5일',
        'likeCount': 3,
        'isLiked': false
      }
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: "전예나님",
                    style: TextStyles.titleExtraLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: "이\n좋아하실만한 노선",
                        style: TextStyles.titleExtraLarge,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle more tap
                  },
                  child: Row(
                    children: [
                      Text(
                        "더보기",
                        style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/icons/ic_arrow_right.svg",
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (final recommendation in recommendations)
            _buildRecommendItem(
              category: recommendation['category'] as String,
              title: recommendation['title'] as String,
              description: recommendation['description'] as String,
              period: recommendation['period'] as String,
              likeCount: recommendation['likeCount'] as int,
              isLiked: recommendation['isLiked'] as bool,
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendItem({
    required String category,
    required String title,
    required String description,
    required String period,
    required int likeCount,
    required bool isLiked,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  color: ColorStyles.primaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category,
                  style: TextStyles.labelMedium.copyWith(
                    color: ColorStyles.primary,
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyles.titleLarge.copyWith(
                  color: ColorStyles.gray900,
                ),
              ),
              Text(
                description,
                style: TextStyles.bodyLarge.copyWith(
                  color: ColorStyles.gray800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "$period | ",
                    style: TextStyles.bodyMedium.copyWith(
                      color: ColorStyles.gray500,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/ic_train.svg",
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    "$likeCount명 탑승중",
                    style: TextStyles.bodyMedium.copyWith(
                      color: ColorStyles.gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  "assets/images/img_dummy_place.png",
                  width: 104,
                  height: 104,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: SvgPicture.asset(
                  isLiked ? "assets/icons/ic_heart_filled.svg" : "assets/icons/ic_heart_white.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantBody() {
    final restaurants = [
      {
        'name': '감나무식당',
        'rating': 4.5,
        'location': '수원',
        'category': '한식',
        'isLiked': true
      },
      {
        'name': '감나무식당',
        'rating': 4.5,
        'location': '수원',
        'category': '한식',
        'isLiked': false
      },
      {
        'name': '감나무식당',
        'rating': 4.5,
        'location': '수원',
        'category': '한식',
        'isLiked': true
      }
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "지역 맛집",
                  style: TextStyles.headlineXSmall
                ),
                GestureDetector(
                  onTap: () {
                    // Handle more tap
                  },
                  child: Row(
                    children: [
                      Text(
                        "더보기",
                        style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/icons/ic_arrow_right.svg",
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 223,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final restaurant in restaurants) ...[
                  _buildRestaurantItem(
                    name: restaurant['name'] as String,
                    rating: restaurant['rating'] as double,
                    location: restaurant['location'] as String,
                    category: restaurant['category'] as String,
                    isLiked: restaurant['isLiked'] as bool,
                  ),
                  const SizedBox(width: 14),
                ]
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _buildRestaurantItem({
    required String name,
    required double rating,
    required String location,
    required String category,
    required bool isLiked
  }) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        "assets/images/img_dummy_place.png",
                        width: 200,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: SvgPicture.asset(
                        isLiked ? "assets/icons/ic_heart_filled.svg" : "assets/icons/ic_heart_white.svg",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  name,
                  style: TextStyles.titleMedium.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_star.svg",
                      width: 18,
                      height: 18
                    ),

                    const SizedBox(width: 2),

                    Text(
                      "$rating | $location | $category",
                      style: TextStyles.bodyMedium.copyWith(
                        color: ColorStyles.gray500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopularPlaceBody() {
    final places = [
      {
        'rank': 1,
        'name': '에버랜드',
        'location': '용인',
        'category': '놀이공원',
      },
      {
        'rank': 2,
        'name': '에버랜드',
        'location': '용인',
        'category': '놀이공원',
      },
      {
        'rank': 3,
        'name': '에버랜드',
        'location': '용인',
        'category': '놀이공원',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "인기 여행지 순위",
                  style: TextStyles.headlineXSmall
                ),
                GestureDetector(
                  onTap: () {
                    // Handle more tap
                  },
                  child: Row(
                    children: [
                      Text(
                        "더보기",
                        style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/icons/ic_arrow_right.svg",
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10
            ),
            height: 223,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final place in places) ...[
                  _buildPopularPlaceItem(
                    rank: place['rank'] as int,
                    name: place['name'] as String,
                    location: place['location'] as String,
                    category: place['category'] as String,
                  ),
                  const SizedBox(width: 14),
                ]
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _buildPopularPlaceItem({
    required int rank,
    required String name,
    required String location,
    required String category
  }) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        "assets/images/img_dummy_place.png",
                        width: 145,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: ColorStyles.gray800,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8), bottomRight: Radius.circular(8)
                        ),
                      ),
                      child: Text(
                        "$rank",
                        style: TextStyles.titleXSmall.copyWith(
                          color: ColorStyles.grayWhite
                        )
                      )
                    )
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  name,
                  style: TextStyles.titleMedium.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "$location | $category",
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorStyles.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

