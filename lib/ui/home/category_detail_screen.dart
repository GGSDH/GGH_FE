import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';
import 'package:gyeonggi_express/ui/home/category_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../data/models/trip_theme.dart';
import '../../routes.dart';

class CategoryDetailScreen extends StatefulWidget {
  final TripTheme category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TripTheme> _categories = TripTheme.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.index = _categories.indexOf(widget.category);
    context.read<CategoryDetailBloc>().add(SelectCategory(widget.category));

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final category = _categories[_tabController.index];
        context.read<CategoryDetailBloc>().add(
            SelectCategory(category)
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<CategoryDetailBloc, CategoryDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is CategoryDetailShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(sideEffect.message),
            ),
          );
        }
      },
      child: BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
        builder: (context, state) {
          return Scaffold(
            body: Material(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    AppActionBar(
                      onBackPressed: () => GoRouter.of(context).pop(),
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
                      title: widget.category.title,
                    ),
                    Container(
                      decoration: const BoxDecoration(
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
                          padding: const EdgeInsets.only(left: 20),
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
                              .map((TripTheme category) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Text(category.title),
                          ))
                              .toList(),
                          indicator: const UnderlineTabIndicator(
                            borderSide:
                            BorderSide(width: 1.0, color: ColorStyles.gray900),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: _categories.map((TripTheme category) {
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
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text('${state.tourAreas.length}개',
                                            style: TextStyles.titleSmall.copyWith(
                                              color: ColorStyles.gray900,
                                              fontWeight: FontWeight.w600,
                                            ))
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final result = await GoRouter.of(context).push<List<String>>(
                                            Uri(
                                              path: Routes.areaFilter.path,
                                              queryParameters: {
                                                'selectedAreas': state.selectedSigunguCodes.map((e) => SigunguCode.toJson(e)).join(','),
                                              },
                                            ).toString());

                                        if (result != null) {
                                          context.read<CategoryDetailBloc>().add(
                                            SelectSigunguCodes(result.map((e) => SigunguCode.fromJson(e)).toList())
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
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
                                            getSelectedAreaText(state.selectedSigunguCodes),
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
                                child: state.isLoading ?
                                const Center(child: CircularProgressIndicator()) :
                                CategoryItemList(items: state.tourAreas),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  String getSelectedAreaText(List<SigunguCode> selectedAreas) {
    if (selectedAreas.isEmpty) {
      return '지역';
    } else if (selectedAreas.length == 1) {
      return selectedAreas.first.value;
    } else {
      return '${selectedAreas.first.value} 외 ${selectedAreas.length - 1}';
    }
  }
}

class CategoryItemList extends StatelessWidget {
  final List<TourArea> items;

  const CategoryItemList({super.key, required this.items});

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
                    const SizedBox(height: 12),
                    Text(
                      item.name,
                      style: TextStyles.titleLarge.copyWith(
                        color: ColorStyles.gray900,
                      ),
                    ),
                    Text(
                      '',
                      style: TextStyles.bodyLarge.copyWith(
                        color: ColorStyles.gray800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          item.likedByMe
                              ? "assets/icons/ic_heart_filled.svg"
                              : "assets/icons/ic_heart.svg",
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 1),
                        Text(
                          item.likeCount.toString(),
                          style: TextStyles.bodyXSmall.copyWith(
                              color: ColorStyles.gray500,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 4),
                        Text("|",
                            style: TextStyles.bodyMedium.copyWith(
                                color: ColorStyles.gray300,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(width: 4),
                        Text(
                          item.sigungu.value,
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray500,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 4),
                        Text("|",
                            style: TextStyles.bodyMedium.copyWith(
                                color: ColorStyles.gray300,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(width: 4),
                        Text(
                          item.contentType.value,
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
                    child: CachedNetworkImage(
                      imageUrl: item.image ?? "",
                      placeholder: (context, url) => const AppImagePlaceholder(width: 104, height: 104),
                      errorWidget: (context, url, error) => const AppImagePlaceholder(width: 104, height: 104),
                      width: 104,
                      height: 104,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: SvgPicture.asset(
                      item.likedByMe
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
