import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';
import '../../component/app/app_action_bar.dart';
import '../../component/app/app_button.dart';
import '../../component/app/app_text_field.dart';
import '../../component/range_picker.dart';

class AddPhotobookSelectPeriodScreen extends StatefulWidget {
  const AddPhotobookSelectPeriodScreen({super.key});

  @override
  _AddPhotobookSelectPeriodScreenState createState() => _AddPhotobookSelectPeriodScreenState();
}

class _AddPhotobookSelectPeriodScreenState extends State<AddPhotobookSelectPeriodScreen> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppActionBar(
                onBackPressed: () {
                  GoRouter.of(context).pop();
                },
                rightText: '',
                menuItems: const [],
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "포토북으로 만들고 싶은 여행 기간과\n제목을 입력해 주세요",
                  style: TextStyles.headlineXSmall.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),
              ),

              const SizedBox(height: 38),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "기간",
                  style: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray900,
                  )
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorStyles.gray300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "기간을 선택해 주세요",
                        style: TextStyles.bodyLarge.copyWith(
                          color: ColorStyles.gray500,
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<DateTime>(
                            context: context,
                            builder: (BuildContext context) {
                              return RangePicker();
                            }
                          );
                        },
                        child: SvgPicture.asset(
                          "assets/icons/ic_calendar.svg",
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "제목",
                  style: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray900,
                  )
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                  controller: titleController,
                  hintText: "Ex. 감성힐링선",
                  hintStyle: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray500,
                  ),
                  suffixIconAsset: "assets/icons/ic_clear.svg",
                  onSuffixIconPressed: () {
                    titleController.clear();
                  },
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(14),
                child: AppButton(
                  text: "다음",
                  onPressed: () {
                    GoRouter.of(context).push("/add-photobook-date-selection");
                  },
                  isEnabled: true,
                  onIllegalPressed: () {},
                ),
              ),
            ],
          ),
        )
    );
  }
}