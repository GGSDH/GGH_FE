import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/home/recommended_lane_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/sigungu_code.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../../util/toast_util.dart';
import '../component/app/app_action_bar.dart';
import '../component/lane/lane_list_item.dart';

class RecommendedLaneScreen extends StatefulWidget {
  const RecommendedLaneScreen({super.key});

  @override
  State<RecommendedLaneScreen> createState() => _RecommendedLaneScreenState();
}

class _RecommendedLaneScreenState extends State<RecommendedLaneScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RecommendedLaneBloc,
        RecommendedLaneSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is RecommendedLaneShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        }
      },
      child: BlocBuilder<RecommendedLaneBloc, RecommendedLaneState>(
        builder: (context, state) {
          return Scaffold(
            body: Material(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    AppActionBar(
                      onBackPressed: () => GoRouter.of(context).pop(),
                      title: "좋아하실 만한 노선",
                    ),
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
                              const SizedBox(width: 4),
                              Text('${state.lanes.length}개',
                                  style: TextStyles.titleSmall.copyWith(
                                    color: ColorStyles.gray900,
                                    fontWeight: FontWeight.w600,
                                  ))
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await GoRouter.of(context).push<List<String>>(
                                Uri(
                                  path: Routes.areaFilter.path,
                                  queryParameters: {
                                    'selectedAreas': state.selectedSigunguCodes
                                        .map((e) => SigunguCode.toJson(e))
                                        .join(','),
                                  },
                                ).toString(),
                              );

                              if (result != null) {
                                context.read<RecommendedLaneBloc>().add(
                                    SelectSigunguCodes(result
                                        .map((e) => SigunguCode.fromJson(e))
                                        .toList()));
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
                                  getSelectedAreaText(
                                      state.selectedSigunguCodes),
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<RecommendedLaneBloc>()
                              .add(RecommendedLaneRefresh());
                          await context
                              .read<RecommendedLaneBloc>()
                              .stream
                              .firstWhere((state) => !state.isRefreshing);
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            if (state.isRefreshing)
                              const SliverToBoxAdapter(
                                  child: LinearProgressIndicator()),
                            if (state.isInitialLoading)
                              const SliverFillRemaining(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            else if (state.lanes.isEmpty)
                              SliverFillRemaining(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_search_empty.svg',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "정보를 수집하고 있습니다.",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final lane = state.lanes[index];
                                    return InkWell(
                                      onTap: () {
                                        GoRouter.of(context).push(
                                            '${Routes.lanes.path}/${lane.laneId}');
                                      },
                                      child: LaneListItem(
                                        onClick: () {
                                          GoRouter.of(context).push(
                                              '${Routes.lanes.path}/${lane.laneId}');
                                        },
                                        onLike: () {
                                          context
                                              .read<RecommendedLaneBloc>()
                                              .add(LikeLane(lane.laneId));
                                        },
                                        onUnlike: () {
                                          context
                                              .read<RecommendedLaneBloc>()
                                              .add(UnlikeLane(lane.laneId));
                                        },
                                        category: lane.category.title,
                                        title: lane.laneName,
                                        description: '',
                                        image: lane.image,
                                        period: lane.getPeriodString(),
                                        likeCount: lane.likeCount,
                                        isLiked: lane.likedByMe,
                                      ),
                                    );
                                  },
                                  childCount: state.lanes.length,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
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
