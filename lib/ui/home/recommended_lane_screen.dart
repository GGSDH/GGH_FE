import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/home/recommended_lane_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/sigungu_code.dart';
import '../../data/repository/trip_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';
import '../component/lane/lane_list_item.dart';

class RecommendedLaneScreen extends StatelessWidget {
  const RecommendedLaneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendedLaneBloc(
        tripRepository: GetIt.instance<TripRepository>(),
      )..add(RecommendedLaneInitialize()),
      child: BlocSideEffectListener<RecommendedLaneBloc,
          RecommendedLaneSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is RecommendedLaneShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
          }
        },
        child: BlocBuilder<RecommendedLaneBloc, RecommendedLaneState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
                                  final result = await GoRouter.of(context)
                                      .push<List<String>>(Uri(
                                    path: Routes.areaFilter.path,
                                    queryParameters: {
                                      'selectedAreas': state
                                          .selectedSigunguCodes
                                          .map((e) => SigunguCode.toJson(e))
                                          .join(','),
                                    },
                                  ).toString());

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
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 8, 8),
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
                          child: ListView.builder(
                            itemCount: state.lanes.length,
                            itemBuilder: (context, index) {
                              return LaneListItem(
                                onClick: () => {},
                                onLike: () => {},
                                onUnlike: () => {},
                                category: state.lanes[index].category.title,
                                title: state.lanes[index].laneName,
                                description: '',
                                image: state.lanes[index].image,
                                period: "당일치기",
                                likeCount: state.lanes[index].likeCount,
                                isLiked: false,
                              );
                            },
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
