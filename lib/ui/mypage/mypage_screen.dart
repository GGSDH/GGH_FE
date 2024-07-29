import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/login_provider.dart';
import '../../data/repository/auth_repository.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import 'mypage_bloc.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyPageBloc(
        authRepository: GetIt.instance<AuthRepository>(),
      ),
      child: BlocSideEffectListener<MyPageBloc, MyPageSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is MyPageNavigateToSetting) {
            context.push('/mypage/setting?nickname=${sideEffect.nickname}&email=${sideEffect.email}&loginType=${sideEffect.loginType.name}');
          } else if (sideEffect is MyPageShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
          }
        },
        child: BlocBuilder<MyPageBloc, MyPageState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SafeArea(
                child: MyPageContent(
                  onTapSetting: () {
                    context.read<MyPageBloc>().add(
                      MyPageSettingButtonClicked(
                        email: state.email,
                        nickname: state.nickname,
                        loginType: state.loginProvider,
                      )
                    );
                  },
                  onTapLocInfoTerms: () {
                    context.push('/mypage/policy/privacy?title=위치정보 이용약관&url=${Constants.LOCATION_INFO_TERMS_URL}');
                  },
                  onTapPrivacyPolicy: () {
                    context.push('/mypage/policy/privacy?title=개인정보 처리방침&url=${Constants.PRIVACY_POLICY_URL}');
                  },
                  onTapTermsOfUse: () {
                    context.push('/mypage/policy/privacy?title=서비스 이용약관&url=${Constants.TERMS_OF_USE_URL}');
                  },
                  onTapLogOut: () {
                    _showLogoutDialog(context);
                  },
                  onTapWithdrawal: () {
                    _showWithdrawalDialog(context);
                  },
                  nickname: state.nickname,
                  email: state.email,
                  loginProvider: state.loginProvider,
                ),
              );
            }
          }
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "로그아웃 하시겠습니까?",
                style: TextStyles.titleLarge,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.gray100,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "취소",
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.gray500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "확인",
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.grayWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/ic_warning.svg",
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 10),
              Text(
                  "정말로 경기선을 탈퇴하시겠습니까?",
                  style: TextStyles.titleLarge.copyWith(
                      color: ColorStyles.gray800
                  )
              ),
              const SizedBox(height: 8),
              Text(
                "지금 탈퇴하시면,\n모든 데이터가 삭제되어 복구될 수 없어요",
                style: TextStyles.bodyMedium.copyWith(
                    color: ColorStyles.gray600
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.gray100,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "취소",
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.gray500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "확인",
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.grayWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MyPageContent extends StatelessWidget {
  final VoidCallback onTapSetting;
  final VoidCallback onTapLocInfoTerms;
  final VoidCallback onTapPrivacyPolicy;
  final VoidCallback onTapTermsOfUse;
  final VoidCallback onTapLogOut;
  final VoidCallback onTapWithdrawal;

  final String nickname;
  final String email;
  final LoginProvider loginProvider;

  const MyPageContent({
    super.key,
    required this.onTapSetting,
    required this.onTapLocInfoTerms,
    required this.onTapPrivacyPolicy,
    required this.onTapTermsOfUse,
    required this.onTapLogOut,
    required this.onTapWithdrawal,
    required this.nickname,
    required this.email,
    required this.loginProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        _buildProfileSection(
          onTapSetting: onTapSetting,
          loginProvider: loginProvider,
          nickname: nickname,
          email: email,
        ),
        _buildSettingsSection(
          onTapLocInfoTerms: onTapLocInfoTerms,
          onTapPrivacyPolicy: onTapPrivacyPolicy,
          onTapTermsOfUse: onTapTermsOfUse,
          onTapLogOut: onTapLogOut,
          onTapWithdrawal: onTapWithdrawal,
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required VoidCallback onTapLocInfoTerms,
    required VoidCallback onTapTermsOfUse,
    required VoidCallback onTapPrivacyPolicy,
    required VoidCallback onTapLogOut,
    required VoidCallback onTapWithdrawal,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "설정",
            style: TextStyles.titleLarge,
          ),
          _buildMenuItem(
            "assets/icons/ic_gps.svg",
            "위치정보 이용약관",
            onTapLocInfoTerms,
          ),
          _buildMenuItem(
            "assets/icons/ic_terms_of_use.svg",
            "서비스 이용약관",
            onTapTermsOfUse,
          ),
          _buildMenuItem(
            "assets/icons/ic_privacy_policy.svg",
            "개인정보 처리방침",
            onTapPrivacyPolicy,
          ),
          _buildMenuItem(
            "assets/icons/ic_logout.svg",
            "로그아웃",
            onTapLogOut,
          ),
          _buildVersionInfoItem("1.0.0v"),
          _buildWithdrawalButton(onTapWithdrawal),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String assetPath, String menuText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              menuText,
              style: TextStyles.bodyLarge.copyWith(
                color: ColorStyles.gray900,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              "assets/icons/ic_arrow_right.svg",
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfoItem(String version) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_info.svg',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
          Text(
            '버전 정보',
            style: TextStyles.bodyLarge.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
          const Spacer(),
          Text(
            version,
            style: TextStyles.titleMedium.copyWith(
              color: ColorStyles.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalButton(VoidCallback onTap) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            "탈퇴하기",
            style: TextStyles.bodyMedium.copyWith(
              color: ColorStyles.gray500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "마이",
            style: TextStyles.headlineXSmall.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
          Row(
            children: [
              _buildIconButton(
                "assets/icons/ic_heart_white.svg",
                    () {
                  // Handle heart icon tap
                },
              ),
              const SizedBox(width: 14),
              _buildIconButton(
                "assets/icons/ic_search_white.svg",
                    () {
                  // Handle search icon tap
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required Function() onTapSetting,
    required LoginProvider loginProvider,
    required String nickname,
    required String email,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Stack(
            children: [
              Image.network(
                "",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    "assets/icons/ic_default_profile.svg",
                    width: 60,
                    height: 60,
                  );
                },
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  loginProvider == LoginProvider.kakao
                    ? "assets/icons/ic_profile_kakao.svg"
                    : "assets/icons/ic_profile_google.svg",
                  width: 18,
                  height: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nickname,
                  style: TextStyles.titleLarge.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorStyles.gray400,
                  ),
                ),
              ],
            ),
          ),
          _buildIconButton(
            "assets/icons/ic_setting.svg",
            onTapSetting,
            width: 36,
            height: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onTap, {double width = 24, double height = 24}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
      ),
    );
  }
}