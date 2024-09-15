import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../../util/toast_util.dart';
import '../component/app/app_text_field.dart';
import 'mypage_setting_bloc.dart';

class MyPageSettingScreen extends StatefulWidget {
  final String nickname;
  final LoginProvider loginType;

  const MyPageSettingScreen({
    super.key,
    required this.nickname,
    required this.loginType,
  });

  @override
  _MyPageSettingScreenState createState() => _MyPageSettingScreenState();
}

class _MyPageSettingScreenState extends State<MyPageSettingScreen> {
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocSideEffectListener<MyPageSettingBloc, MyPageSettingSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is MyPageSettingShowError) {
            ToastUtil.showToast(context, sideEffect.message);
          } else if (sideEffect is MyPageSettingNavigateToMyPage) {
            GoRouter.of(context).pop();
          }
        },
        child: BlocBuilder<MyPageSettingBloc, MyPageSettingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return MyPageSettingScreenContent(
                nicknameController: _nicknameController,
                loginType: state.loginType,
                onSave: () {
                  context.read<MyPageSettingBloc>().add(
                    MyPageSettingSaveButtonClicked(
                      nickname: _nicknameController.text,
                    ),
                  );
                },
              );
            }
          },
        ),
      );
  }
}

class MyPageSettingScreenContent extends StatelessWidget {
  final TextEditingController nicknameController;
  final LoginProvider loginType;
  final VoidCallback onSave;

  const MyPageSettingScreenContent({
    super.key,
    required this.nicknameController,
    required this.loginType,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(
              onTapBack: () {
                context.pop();
              },
            ),
            _buildProfileImageSection(),
            _buildNicknameSection(),
            const Spacer(),
            _buildSaveButton(onSave),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar({required Function() onTapBack}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onTapBack,
              child: SvgPicture.asset(
                'assets/icons/ic_arrow_back.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Center(
            child: Text(
              "내정보",
              style: TextStyles.titleLarge.copyWith(
                color: ColorStyles.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_default_profile.svg',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: TextStyles.bodyLarge.copyWith(
              color: ColorStyles.gray800,
            ),
          ),
          const SizedBox(height: 8),

          AppTextField(
            controller: nicknameController,
            hintText: "닉네임을 입력해주세요",
            hintStyle: TextStyles.bodyLarge.copyWith(
              color: ColorStyles.gray500,
            ),
            suffixIconAsset: "assets/icons/ic_clear.svg",
            onSuffixIconPressed: () {
              nicknameController.clear();
            },
          )
        ],
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    final isValid = nicknameController.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: isValid ? ColorStyles.primary : ColorStyles.gray100,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "변경사항 저장",
            style: TextStyles.titleMedium.copyWith(
              color: isValid ? Colors.white : ColorStyles.gray500,
            ),
          ),
        ),
      ),
    );
  }
}
