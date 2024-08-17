import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../routes.dart';
import '../../../themes/text_styles.dart';
import 'add_photobook_bloc.dart';

class AddPhotobookLoadingScreen extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String title;

  const AddPhotobookLoadingScreen({
    required this.startDate,
    required this.endDate,
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPhotobookBloc(
        photobookRepository: GetIt.instance<PhotobookRepository>(),
      )..add(
        AddPhotobookUpload(
          title: title,
          startDate: DateTime.parse(startDate),
          endDate: DateTime.parse(endDate),
        ),
      ),
      child: BlocSideEffectListener<AddPhotobookBloc, AddPhotobookSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is AddPhotobookShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
          } else if (sideEffect is AddPhotobookComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(context).go(
                Uri(
                  path: "${Routes.photobook.path}/${Routes.photobookCard.path}",
                  queryParameters: {
                    "photobookId": sideEffect.photobookId.toString(),
                  },
                ).toString(),
              );
            });
          }
        },
        child: BlocBuilder<AddPhotobookBloc, AddPhotobookState>(
          builder: (context, state) {
            return Scaffold(
              body: Material(
                color: Colors.white,
                child: Center(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "소중한 추억이 담긴\n포토북을 생성중이예요",
                          style: TextStyles.title2ExtraLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 100),
                        SvgPicture.asset(
                          "assets/icons/img_add_photobook_loading_illust.svg",
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}