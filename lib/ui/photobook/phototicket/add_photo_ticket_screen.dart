import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';
import '../../../util/toast_util.dart';
import '../../component/app/app_action_bar.dart';
import '../../component/app/app_button.dart';
import '../../component/photo_ticket_item.dart';
import 'add_photo_ticket_bloc.dart';

class AddPhotoTicketScreen extends StatelessWidget {

  const AddPhotoTicketScreen({ super.key });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocSideEffectListener<AddPhotoTicketBloc, AddPhotoTicketSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is UploadPhotoTicketComplete) {
          GoRouter.of(context).pop(true);
        } else if (sideEffect is AddPhotoTicketShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        }
      },
      child: BlocBuilder<AddPhotoTicketBloc, AddPhotoTicketState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            body: Material(
              color: Colors.white,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -100,
                      child: SvgPicture.asset(
                        "assets/icons/ic_photo_ticket_illust.svg",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppActionBar(
                        onBackPressed: () => GoRouter.of(context).pop(),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "짜잔, 소중한 추억이예요",
                            style: TextStyles.title2ExtraLarge.copyWith(
                              color: ColorStyles.gray900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "이 사진을 포토티켓으로 남길 것인가요?",
                            style: TextStyles.bodyLarge.copyWith(
                              color: ColorStyles.gray500,
                            )
                          ),
                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).pop();
                            },
                            child: SizedBox(
                              width: screenWidth * 0.7,
                              child: AspectRatio(
                                aspectRatio: 0.7,
                                child: PhotoTicketItem(
                                  title: state.title,
                                  filePath: state.selectedPhotoPath,
                                  startDate: state.startDate.isNotEmpty ? DateTime.parse(state.startDate) : null,
                                  endDate: state.endDate.isNotEmpty ? DateTime.parse(state.endDate) : null,
                                  location: state.location,
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(14),
                        child: AppButton(
                          text: '포토티켓 발행',
                          onPressed: () {
                            context.read<AddPhotoTicketBloc>().add(UploadPhotoTicket(state.selectedPhotoId));
                          },
                          isEnabled: state.selectedPhotoId.isNotEmpty
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

