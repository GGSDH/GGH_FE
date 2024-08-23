import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/local_restaurant_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';
import '../component/app/app_image_plaeholder.dart';
import 'local_restaruant_bloc.dart';

class LocalRestaurantScreen extends StatefulWidget {
  const LocalRestaurantScreen({super.key});

  @override
  _LocalRestaurantScreenState createState() => _LocalRestaurantScreenState();
}

class _LocalRestaurantScreenState extends State<LocalRestaurantScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isReachEnd) {
      context.read<LocalRestaurantBloc>().add(LocalRestaurantFetched());
    }
  }

  bool get _isReachEnd {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<LocalRestaurantBloc, LocalRestaurantSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is LocalRestaurantShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(sideEffect.message)),
          );
        }
      },
      child: BlocBuilder<LocalRestaurantBloc, LocalRestaurantState>(
        builder: (context, state) {
          if (state.isInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              body: Material(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      AppActionBar(
                        rightText: "",
                        onBackPressed: () => Navigator.pop(context),
                        menuItems: const [],
                        title: "지역 맛집",
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
                                Text('${state.localRestaurants.length}개',
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
                                  context.read<LocalRestaurantBloc>().add(
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
                                  side: BorderSide(color: Colors.grey[200]!, width: 1),
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
                        child: RestaurantItemList(
                          items: state.localRestaurants,
                          scrollController: _scrollController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
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

class RestaurantItemList extends StatelessWidget {
  final List<LocalRestaurant> items;
  final ScrollController scrollController;

  const RestaurantItemList({
    super.key,
    required this.items,
    required this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _restaurantListItem(item);
      },
      controller: scrollController,
    );
  }

  Container _restaurantListItem(LocalRestaurant item) {
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
                  "",
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
                      item.sigunguValue,
                      style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    Text("|",
                        style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray300,
                            fontWeight: FontWeight.w400)),
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
  }
}
