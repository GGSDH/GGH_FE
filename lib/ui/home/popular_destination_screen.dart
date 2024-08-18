import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/home/popular_destination_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/popular_destination_response.dart';
import '../component/app/app_image_plaeholder.dart';

class PopularDestinationScreen extends StatelessWidget {
  const PopularDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<PopularDestinationBloc, PopularDestinationSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PopularDestinationShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(sideEffect.message)),
          );
        }
      },
      child: BlocBuilder<PopularDestinationBloc, PopularDestinationState>(
        builder: (context, state) {
          if (state.isLoading) {
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
                        title: "인기 여행지 순위",
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: state.popularDestinations.isNotEmpty
                              ? ListView.builder(
                            itemCount: (state.popularDestinations.isEmpty)
                                ? 0
                                : (state.popularDestinations.length / 2).ceil(),
                            itemBuilder: (context, index) {
                              if (state.popularDestinations.isEmpty) {
                                // 만약 데이터가 없거나 null이라면 안전하게 처리
                                return const Center(
                                  child: Text(
                                    'No destinations available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                );
                              }

                              final firstDestination = (index * 2 < state.popularDestinations.length)
                                  ? state.popularDestinations[index * 2]
                                  : null;
                              final secondDestination = (index * 2 + 1 < state.popularDestinations.length)
                                  ? state.popularDestinations[index * 2 + 1]
                                  : null;

                              print('firstDestination: $firstDestination');
                              print('secondDestination: $secondDestination');

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: firstDestination != null
                                          ? DestinationItem(destination: firstDestination)
                                          : const SizedBox(),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: secondDestination != null
                                          ? DestinationItem(destination: secondDestination)
                                          : const SizedBox(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                          : const SizedBox()
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      ),
    );
  }
}

class DestinationItem extends StatelessWidget {
  final PopularDestination destination;

  const DestinationItem({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    const double aspectRatio = 1.17;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 추가된 부분: Column이 자식의 크기에 맞게 줄어들도록 설정
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: destination.image ?? "",
                  placeholder: (context, url) => const AppImagePlaceholder(width: double.infinity, height: 145),
                  errorWidget: (context, url, error) => const AppImagePlaceholder(width: double.infinity, height: 145),
                  width: double.infinity,
                  height: 145,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorStyles.gray800,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  '${destination.ranking}',
                  style: TextStyles.titleXSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          destination.name,
          style: TextStyles.titleMedium.copyWith(color: ColorStyles.gray900, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              destination.sigunguValue,
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
              destination.category.title,
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
