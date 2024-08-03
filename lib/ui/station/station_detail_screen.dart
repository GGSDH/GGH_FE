import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/%08blog/blog_list_item.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/restaurant/restaurant_list_item.dart';

class StationDetailScreen extends StatefulWidget {
  static const images = [
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/300"
  ];

  static const summaryImage = "https://picsum.photos/800/300";

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
            child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _bottomNavigationBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppActionBar(
                    rightText: "",
                    onBackPressed: () => {},
                    menuItems: [
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
                _imageViewer(),
                _stationHeader(),
                const Divider(
                  color: ColorStyles.gray100,
                  thickness: 1,
                ),
                _stationSummary(),
                const Divider(
                  color: ColorStyles.gray100,
                  thickness: 1,
                ),
                _laneIncludingStation(),
                const Divider(
                  color: ColorStyles.gray100,
                  thickness: 1,
                ),
                _nearbyRecommendations(),
                const Divider(
                  color: ColorStyles.gray100,
                  thickness: 1,
                ),
                _buildBlogReviews(),
              ],
            ),
          ),
        )));
  }

  Widget _bottomNavigationBar() {
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _buildNavigationItem(
                  SvgPicture.asset(
                    "assets/icons/ic_marker_01.svg",
                    width: 24,
                    height: 24,
                  ),
                  "1"),
              _buildNavigationItem(
                  SvgPicture.asset(
                    "assets/icons/ic_heart.svg",
                    width: 24,
                    height: 24,
                  ),
                  "2"),
              _buildNavigationItem(
                  SvgPicture.asset(
                    "assets/icons/ic_message_circle_2.svg",
                    width: 24,
                    height: 24,
                  ),
                  "3"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(Widget icon, String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyles.bodyXSmall.copyWith(
                color: ColorStyles.gray500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _laneIncludingStation() {
    final lanes = [
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("이 역이 포함된 노선들", style: TextStyles.headlineXSmall),
                Row(
                  children: [
                    Text("더보기",
                        style: TextStyles.bodyMedium
                            .copyWith(color: ColorStyles.gray500)),
                    SvgPicture.asset(
                      "assets/icons/ic_arrow_right.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                )
              ]),
        ),
        ...lanes.map(
          (lane) {
            return LaneListItem(
              category: lane['category'] as String,
              title: lane['title'] as String,
              description: lane['description'] as String,
              period: lane['period'] as String,
              likeCount: lane['likeCount'] as int,
              isLiked: lane['isLiked'] as bool,
            );
          },
        )
      ],
    );
  }

  Widget _stationSummary() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Station Summary", style: TextStyles.titleLarge),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Station Summary Description",
              style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray600),
            ),
            const SizedBox(
              height: 24,
            ),
            Image.network(
              StationDetailScreen.summaryImage,
              fit: BoxFit.cover,
              height: 295,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }

  Widget _stationHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 18,
                child: SvgPicture.asset(
                  "assets/icons/ic_map_pin.svg",
                  width: 18,
                  height: 18,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "서울역",
                style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w400, color: ColorStyles.primary),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Text("Station Name", style: TextStyles.title2ExtraLarge),
          const SizedBox(
            height: 4,
          ),
          Text("Station Name",
              style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray600)),
        ],
      ),
    );
  }

  Widget _nearbyRecommendations() {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("주변 추천 장소", style: TextStyles.headlineXSmall),
                Row(
                  children: [
                    Text("더보기",
                        style: TextStyles.bodyMedium
                            .copyWith(color: ColorStyles.gray500)),
                    SvgPicture.asset(
                      "assets/icons/ic_arrow_right.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                )
              ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...restaurants.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final restaurant = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index != restaurants.length - 1 ? 14 : 0,
                      ),
                      child: RestaurantListItem(
                        name: restaurant['name'] as String,
                        rating: restaurant['rating'] as double,
                        location: restaurant['location'] as String,
                        category: restaurant['category'] as String,
                        isLiked: restaurant['isLiked'] as bool,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _imageViewer() {
    return SizedBox(
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "${_currentPage + 1}/${StationDetailScreen.images.length}",
                style: TextStyles.titleXSmall.copyWith(
                    fontWeight: FontWeight.w600, color: ColorStyles.grayWhite),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBlogReviews() {
    final blogItems = [
      {
        "title": "블로그 제목",
        "date": "2021.08.01",
        "imageUrl": "https://picsum.photos/200/200",
        "articleUrl": "https://www.naver.com"
      },
      {
        "title": "블로그 제목",
        "date": "2021.08.01",
        "imageUrl": "https://picsum.photos/200/200",
        "articleUrl": "https://www.naver.com"
      },
      {
        "title": "블로그 제목",
        "date": "2021.08.01",
        "imageUrl": "https://picsum.photos/200/200",
        "articleUrl": "https://www.naver.com"
      }
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("추천 블로그 리뷰", style: TextStyles.headlineXSmall),
                Row(
                  children: [
                    Text("더보기",
                        style: TextStyles.bodyMedium
                            .copyWith(color: ColorStyles.gray500)),
                    SvgPicture.asset(
                      "assets/icons/ic_arrow_right.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                )
              ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                blogItems.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index != blogItems.length - 1 ? 14 : 0,
                  ),
                  child: BlogListItem(
                    title: blogItems[index]['title'] as String,
                    date: blogItems[index]['date'] as String,
                    imageUrl: blogItems[index]['imageUrl'] as String,
                    articleUrl: blogItems[index]['articleUrl'] as String,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 34,
        )
      ],
    );
  }
}
