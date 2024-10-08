import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes.dart';
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
  DateTime? startDate;
  DateTime? endDate;

  final dateFormat = DateFormat("yyyy.MM.dd");

  Future<void> _showRangePicker(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String,DateTime>>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            RangePicker(
              onConfirmed: (startDate, endDate) {
                GoRouter.of(context).pop({
                  "startDate": startDate,
                  "endDate": endDate,
                });
              }
            ),
          ]
        );
      }
    );

    if (result != null) {
      setState(() {
        startDate = result["startDate"];
        endDate = result["endDate"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    titleController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    titleController.dispose();
    titleController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});  // Rebuild to update the suffix icon
  }

  Future<void> requestPermissions() async {
    await Permission.photos.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppActionBar(
                onBackPressed: () {
                  GoRouter.of(context).pop();
                },
                rightText: '1/2',
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
                        startDate != null && endDate != null
                            ? "${dateFormat.format(startDate!)} ~ ${dateFormat.format(endDate!)}"
                            : "기간을 선택해 주세요",
                        style: TextStyles.bodyLarge.copyWith(
                          color: startDate != null && endDate != null
                            ? ColorStyles.gray900
                            : ColorStyles.gray500,
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          _showRangePicker(context);
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
                  onPressed: () async {
                    // 사진 권한과 위치 권한을 동시에 요청
                    final photosStatus = await Permission.photos.request();

                    // 둘 중 하나라도 영구적으로 거부되면 앱 설정 열기
                    if (photosStatus.isPermanentlyDenied) {
                      await openAppSettings();
                    }
                    // 둘 다 권한이 허용된 경우
                    else if (photosStatus.isGranted) {
                      final startDateTime = DateTime(startDate!.year, startDate!.month, startDate!.day, 0, 0, 0);
                      final endDateTime = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);

                      GoRouter.of(context).push(
                          "${Routes.photobook.path}/${Routes.addPhotobook.path}/${Routes.addPhotobookLoading.path}?startDate=$startDateTime&endDate=$endDateTime&title=${titleController.text}"
                      );
                    }
                    // 권한이 거부된 경우
                    else {
                      print("권한이 거부되었습니다.");
                    }
                  },
                  isEnabled: startDate != null && endDate != null && titleController.text.isNotEmpty,
                  onIllegalPressed: () {},
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}