import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class Category {
  final String name;
  final List<CategoryItem> items;

  Category({required this.name, required this.items});
}

class CategoryItem {
  final String title;
  final String description;
  final int likeCount;
  final String region;
  final String type;
  final String imagePath;
  final bool isLiked;

  CategoryItem({
    required this.title,
    required this.description,
    required this.likeCount,
    required this.region,
    required this.type,
    required this.imagePath,
    required this.isLiked,
  });
}

class CategoryExplorerScreen extends StatefulWidget {
  final String categoryName;

  const CategoryExplorerScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  _CategoryExplorerScreenState createState() => _CategoryExplorerScreenState();
}

class _CategoryExplorerScreenState extends State<CategoryExplorerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  void _initializeData() {
    _categories = [
      Category(name: '체험', items: _generateItems('체험')),
      Category(name: '핫플', items: _generateItems('핫플')),
      Category(name: '관광', items: _generateItems('관광')),
      Category(name: '지역특색', items: _generateItems('지역특색')),
      Category(name: '문화', items: _generateItems('문화')),
      Category(name: '맛집', items: _generateItems('맛집')),
    ];
  }

  List<CategoryItem> _generateItems(String category) {
    return List.generate(
        20,
        (index) => CategoryItem(
              title: '$category 아이템 ${index + 1}',
              description: '$category 아이템 ${index + 1}의 설명입니다.',
              likeCount: 100 + index,
              region: '수원',
              type: '한식',
              imagePath: 'assets/images/img_dummy_place.png',
              isLiked: index % 2 == 0,
            ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              rightText: "",
              onBackPressed: () => context.pop(),
              menuItems: [
                ActionBarMenuItem(
                  icon: SvgPicture.asset(
                    "assets/icons/ic_search.svg",
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {},
                ),
              ],
              title: widget.categoryName,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorStyles.gray200,
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                  padding: EdgeInsets.only(left: 20),
                  dividerHeight: 0,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: ColorStyles.gray900,
                  unselectedLabelColor: ColorStyles.gray400,
                  indicatorColor: ColorStyles.gray900,
                  indicatorWeight: 1,
                  labelStyle: TextStyles.titleMedium,
                  unselectedLabelStyle: TextStyles.bodyLarge,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  tabs: _categories
                      .map((Category category) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Text(category.name),
                          ))
                      .toList(),
                  indicator: UnderlineTabIndicator(
                    borderSide:
                        BorderSide(width: 1.0, color: ColorStyles.gray900),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((Category category) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('전체',
                                    style: TextStyles.bodyMedium.copyWith(
                                        color: ColorStyles.gray700,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('${category.items.length}개',
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
                                padding: EdgeInsets.fromLTRB(12, 8, 8, 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '지역 필터',
                                    style: TextStyles.bodyMedium.copyWith(
                                        color: ColorStyles.gray900,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(width: 12),
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
                        child: CategoryItemList(items: category.items),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItemList extends StatelessWidget {
  final List<CategoryItem> items;

  const CategoryItemList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      item.title,
                      style: TextStyles.titleLarge.copyWith(
                        color: ColorStyles.gray900,
                      ),
                    ),
                    Text(
                      item.description,
                      style: TextStyles.bodyLarge.copyWith(
                        color: ColorStyles.gray800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          item.isLiked
                              ? "assets/icons/ic_heart_filled.svg"
                              : "assets/icons/ic_heart.svg",
                          width: 18,
                          height: 18,
                        ),
                        SizedBox(width: 1),
                        Text(
                          item.likeCount.toString(),
                          style: TextStyles.bodyXSmall.copyWith(
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
                          item.region,
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
                          item.type,
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray500,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      item.imagePath,
                      width: 104,
                      height: 104,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: SvgPicture.asset(
                      item.isLiked
                          ? "assets/icons/ic_heart_filled.svg"
                          : "assets/icons/ic_heart_white.svg",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
