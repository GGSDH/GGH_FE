import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';

class PopularDestination {
  final String name;
  final String imagePath;
  final int rank;
  final String region;
  final String category;

  PopularDestination({
    required this.name,
    required this.imagePath,
    required this.rank,
    required this.region,
    required this.category,
  });
}

class PopularDestinationsScreen extends StatelessWidget {
  final List<PopularDestination> destinations = [
    PopularDestination(
      name: "에버랜드",
      imagePath: "https://picsum.photos/seed/everland/200/300",
      rank: 1,
      region: "용인",
      category: "테마파크",
    ),
    PopularDestination(
      name: "남이섬",
      imagePath: "https://picsum.photos/seed/nami/200/300",
      rank: 2,
      region: "가평",
      category: "자연",
    ),
    PopularDestination(
      name: "수원화성",
      imagePath: "https://picsum.photos/seed/suwon/200/300",
      rank: 3,
      region: "수원",
      category: "역사",
    ),
    PopularDestination(
      name: "아침고요수목원",
      imagePath: "https://picsum.photos/seed/morning/200/300",
      rank: 4,
      region: "가평",
      category: "자연",
    ),
  ];

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
              menuItems: [],
              title: "인기 여행지 순위",
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: (destinations.length / 2).ceil(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DestinationItem(destination: destinations[index * 2]),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: index * 2 + 1 < destinations.length
                              ? DestinationItem(destination: destinations[index * 2 + 1])
                              : SizedBox(),
                        ),
                      ],
                    ),
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

class DestinationItem extends StatelessWidget {
  final PopularDestination destination;

  const DestinationItem({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                destination.imagePath,
                height: 145,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorStyles.gray800,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  '${destination.rank}',
                  style: TextStyles.titleXSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
            destination.name,
            style: TextStyles.titleMedium.copyWith(color: ColorStyles.gray900, fontWeight: FontWeight.w600)
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Text(
              destination.region,
              style: TextStyles.bodyMedium.copyWith(
                  color: ColorStyles.gray500,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(width: 4),
            Text("|",
                style: TextStyles.bodyMedium.copyWith(
                    color: ColorStyles.gray300,
                    fontWeight: FontWeight.w400)),
            SizedBox(width: 4),
            Text(
              destination.category,
              style: TextStyles.bodyMedium.copyWith(
                  color: ColorStyles.gray500,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ],
    );
  }
}