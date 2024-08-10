import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';
import '../component/lane/lane_list_item.dart';

class RecommendedLaneScreen extends StatelessWidget {
  final List<LaneListItem> laneList = [
    LaneListItem(
      category: "인기",
      title: "경기도 근교 당일치기 여행",
      description: "한탄강 협곡부터 연인산 도립공원까지",
      period: "당일",
      likeCount: 128,
      isLiked: true,
    ),
    LaneListItem(
      category: "테마",
      title: "경기도 남부 문화유산 탐방",
      description: "수원화성과 융건릉을 중심으로",
      period: "1박 2일",
      likeCount: 95,
      isLiked: false,
    ),
  ];

  RecommendedLaneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              rightText: "",
              onBackPressed: () => Navigator.pop(context),
              menuItems: const [],
              title: "좋아하실 만한 노선",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('전체',
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray700,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(width: 4),
                      Text('${laneList.length}개',
                          style: TextStyles.titleSmall.copyWith(
                            color: ColorStyles.gray900,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '지역',
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray900,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 12),
                        SvgPicture.asset(
                          "assets/icons/ic_chevron_right.svg",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: laneList.length,
                itemBuilder: (context, index) {
                  return LaneListItem(
                    category: laneList[index].category,
                    title: laneList[index].title,
                    description: laneList[index].description,
                    period: laneList[index].period,
                    likeCount: laneList[index].likeCount,
                    isLiked: laneList[index].isLiked,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}