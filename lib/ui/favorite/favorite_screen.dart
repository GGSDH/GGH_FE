import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/place/place_list_item.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Map<String, dynamic>> laneList = [
    {
      "category": "국내여행",
      "title": "제주도 힐링 여행",
      "description": "아름다운 해변과 오름을 따라 떠나는 4일간의 여정",
      "image": "https://picsum.photos/seed/jeju/200/300",
      "period": "4일",
      "likeCount": 1500,
      "isLiked": true,
    },
    {
      "category": "해외여행",
      "title": "유럽 문화 탐방",
      "description": "파리, 로마, 바르셀로나를 아우르는 2주 일정",
      "image": "https://picsum.photos/seed/europe/200/300",
      "period": "14일",
      "likeCount": 2300,
      "isLiked": false,
    },
    {
      "category": "국내여행",
      "title": "부산 맛집 투어",
      "description": "부산의 명물 먹거리를 찾아 떠나는 맛있는 여행",
      "image": "https://picsum.photos/seed/busan/200/300",
      "period": "3일",
      "likeCount": 980,
      "isLiked": true,
    },
  ];

  final List<Map<String, dynamic>> placeList = [
    {
      "name": "경복궁",
      "description": "조선시대의 대표적인 궁궐, 서울의 중심에서 역사를 만나다",
      "image": "https://picsum.photos/seed/gyeongbokgung/200/300",
      "likeCount": 3200,
      "likedByMe": true,
      "sigunguValue": "서울특별시 종로구",
    },
    {
      "name": "해운대 해수욕장",
      "description": "부산의 상징, 아름다운 해변과 현대적인 도시의 조화",
      "image": "https://picsum.photos/seed/haeundae/200/300",
      "likeCount": 2800,
      "likedByMe": false,
      "sigunguValue": "부산광역시 해운대구",
    },
    {
      "name": "설악산 국립공원",
      "description": "한국의 아름다운 산세, 사계절 모두 매력적인 국립공원",
      "image": "https://picsum.photos/seed/seoraksan/200/300",
      "likeCount": 1900,
      "likedByMe": true,
      "sigunguValue": "강원도 속초시",
    },
  ];

  // final List<Map<String, dynamic>> laneList = [];
  // final List<Map<String, dynamic>> placeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: '노선'),
                  Tab(text: '역'),
                ],
                indicatorColor: ColorStyles.gray900,
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: ColorStyles.gray400,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildContent(isLaneTab: true),
                    _buildContent(isLaneTab: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isLaneTab}) {
    final List items = isLaneTab ? laneList : placeList;
    if (items.isEmpty) {
      return _buildEmptyState(isLaneTab);
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (isLaneTab) {
          return LaneListItem(
            category: items[index]['category'],
            title: items[index]['title'],
            description: items[index]['description'],
            image: items[index]['image'],
            period: items[index]['period'],
            likeCount: items[index]['likeCount'],
            isLiked: items[index]['isLiked'],
          );
        } else {
          return PlaceListItem(
            name: items[index]['name'],
            description: items[index]['description'],
            image: items[index]['image'],
            likeCount: items[index]['likeCount'],
            likedByMe: items[index]['likedByMe'],
            sigunguValue: items[index]['sigunguValue'],
          );
        }
      },
    );
  }

  Widget _buildEmptyState(bool isLaneTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_search_empty.svg',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            isLaneTab ? "찜한 노선이 없어요" : "찜한 역이 없어요",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLaneTab ? "내 마음에 쏙 드는 노선을 찜하러 가볼까요?" : "인기 여행지를 찜하러 가볼까요?",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorStyles.gray500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorStyles.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "바로가기",
              style:
                  TextStyles.titleXSmall.copyWith(color: ColorStyles.grayWhite),
            ),
          ),
        ],
      ),
    );
  }
}
