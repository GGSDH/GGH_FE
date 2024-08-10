import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    print("startDate: $startDate, endDate: $endDate, title: $title");

    return BlocProvider(
      create: (context) => AddPhotobookBloc()..add(
        AddPhotobookInitialize(
          title: title,
          startDate: DateTime.parse(startDate),
          endDate: DateTime.parse(endDate),
        ),
      ),
      child: BlocBuilder<AddPhotobookBloc, AddPhotobookState>(
        builder: (context, state) {
          return Material(
            color: Colors.white,
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
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}