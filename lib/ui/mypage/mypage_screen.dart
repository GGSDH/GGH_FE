import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../themes/color_styles.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        _buildProfileSection(
          onTapSetting: () {
            context.push('/mypage/setting');
          },
        ),
        _buildSettingsSection(),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "설정",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildMenuItem(
            "assets/icons/ic_terms_of_use.svg",
            "이용약관",
                () {
              // Handle Terms of Use tap
            },
          ),
          _buildMenuItem(
            "assets/icons/ic_privacy_policy.svg",
            "개인정보 처리방침",
                () {
              // Handle Privacy Policy tap
            },
          ),
          _buildMenuItem(
            "assets/icons/ic_logout.svg",
            "로그아웃",
                () {
              // Handle Logout tap
            },
          ),
          _buildVersionInfoItem("1.0.0v"),
          _buildWithdrawalButton(() {
            // Handle withdrawal tap
          }),
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
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
          const Text(
            '버전 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            version,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            "탈퇴하기",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
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
          const Text(
            "마이",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              _buildIconButton(
                "assets/icons/ic_heart.svg",
                    () {
                  // Handle heart icon tap
                },
              ),
              const SizedBox(width: 14),
              _buildIconButton(
                "assets/icons/ic_search.svg",
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

  Widget _buildProfileSection({required Function() onTapSetting}) {
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
                  "assets/icons/ic_profile_kakao.svg",
                  width: 18,
                  height: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'yena009',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'yena009@naver.com',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "assets/icons/ic_profile_kakao.svg",
                  width: 18,
                  height: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'yena009',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'yena009@naver.com',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ColorStyles.gray400,
                  ),
                ),
              ],
            ),
          ),
          _buildIconButton(
            "assets/icons/ic_setting.svg",
                () {
              context.push('/mypage/setting');
            },
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